" Define plugin default values, if not re-defined by user
if !exists("g:vim_mdtopdf_cssurl")
    let g:vim_mdtopdf_cssurl = "'". shellescape("file://". expand('<sfile>:p:h:h'). "/". "style/md-style.css"). "'"
endif

if !exists("g:vim_mdtopdf_papersize")
    let g:vim_mdtopdf_papersize = "Letter"
endif

let s:vim_mdtopdf_html_includes_path = "'". shellescape("file://". expand('<sfile>:p:h:h'). "/". "html-includes/includes.html"). "'"

function! MdToPdf()
    " Check that Vim has been compiled with python3 support
    if !has('python3')
        echo "Error: Required vim compiled with +python3"
        finish
    endif

    " Convert the markdown + math to html with KaTeX
    lcd %:p:h
    execute "Pandoc html
        \ -f gfm
        \ --standalone
        \ --css ". g:vim_mdtopdf_cssurl. "
        \ -A ". s:vim_mdtopdf_html_includes_path. "
		\ -o '". shellescape(expand("%:r"). ".html"). "'"

    " Run pyppeteer to render the TeX math using MathJax, then save the resulting rendered HTML to a new HTML file that can be turned into a PDF
python3 << EOF
import asyncio
from base64 import b64encode
from lxml import etree
from pyppeteer import launch
import os
import vim
from weasyprint import HTML

async def main():
    # Launch Pyppeteer to render the math using MathJax
    browser = await launch()
    doc = await browser.newPage()
    await doc.goto("file://" + vim.eval("expand('%:p:r')") + ".html")
    await doc.waitForFunction('mathjax_complete === true')
    html = await doc.content()

    # WeasyPrint doesn't support inline SVG in HTML, which is what MathJax generates, so we need to convert the SVG images to base64 strings
    root = etree.HTML(html)
    mjxs = root.findall('.//mjx-container')
    for mjx in mjxs:
        svg = mjx.getchildren()[0]
        # The LXML HTML parser puts all the HTML in lower-case, however that makes the SVG invalid, so the "viewbox" element of the svg tag must be replaced with the orignal "viewBox"
        encoded = b64encode(etree.tostring(svg, method = 'xml', encoding = str).replace("viewbox", "viewBox").encode()).decode()
        data = "data:image/svg+xml;charset=utf8;base64," + encoded
        svg_img = etree.fromstring('<img src="%s"/>' % data)
        mjx.replace(svg, svg_img)
    encoded_html = etree.tostring(root)

    # Write the final, rendered HTML to a PDF file in the same directory as the Markdown file
    HTML(string = encoded_html, base_url = vim.eval("expand('%:p:h')")).write_pdf(vim.eval("expand('%:p:r')") + ".pdf")

    # Remove the HTML file that was generated from the Markdown
    os.remove(vim.eval("expand('%:p:r')") + ".html")
    await browser.close()

asyncio.run(main())
EOF
endfunction

command MdToPdf call MdToPdf()
