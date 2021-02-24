" Define plugin default values, if not re-defined by user
if !exists("g:vim_mdtopdf_cssurl")
    let g:vim_mdtopdf_cssurl = "https://cdn.jsdelivr.net/gh/ryangwsimmons/vim-MdToPdf@master/style/md-style.css"
endif

if !exists("g:vim_mdtopdf_papersize")
    let g:vim_mdtopdf_papersize = "letter"
endif

function! MdToPdf()
    " Check that Vim has been compiled with python3 support
    if !has('python3')
        echo "Error: Required vim compiled with +python3"
        finish
    endif

    " Convert the markdown + math to html with KaTeX
    lcd %:p:h
    execute "Pandoc html
        \ --standalone
		\ --css ". g:vim_mdtopdf_cssurl. "
        \ --katex https://cdn.jsdelivr.net/npm/katex@latest/dist/
		\ -o '". shellescape(expand("%:r"). ".html"). "'"

    " Run pyppeteer to render the TeX math using KaTeX, then save the resulting rendered HTML to a new HTML file that can be turned into a PDF
python3 << EOF
import asyncio
from pyppeteer import launch
import os
import vim
from weasyprint import HTML

async def main():
    browser = await launch()
    doc = await browser.newPage()
    await doc.goto("file://" + vim.eval("expand('%:p:r')") + ".html")
    html = await doc.content()
    HTML(string = html.encode("utf-8")).write_pdf(vim.eval("expand('%:p:r')") + ".pdf")
    os.remove(vim.eval("expand('%:p:r')") + ".html")
    await browser.close()

asyncio.run(main())
EOF
endfunction

command MdToPdf call MdToPdf()
