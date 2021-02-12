" Define plugin default values, if not re-defined by user
if !exists("g:vim_mdtopdf_cssurl")
    let g:vim_mdtopdf_cssurl = "https://cdn.jsdelivr.net/gh/ryangwsimmons/vim-MdToPdf/style/md-style.css"
endif

if !exists("vim_mdtopdf_papersize")
    let g:vim_mdtopdf_papersize = "letter"
endif

function! MdToPdf()
    execute "Pandoc html
		\ --css ". g:vim_mdtopdf_cssurl. "
		\ --katex https://cdn.jsdelivr.net/npm/katex@latest/dist/
		\ -V margin-top=0.5in -V margin-bottom=0.5in -V margin-left=0.5in -V margin-right=0.5in
		\ -V papersize=". g:vim_mdtopdf_papersize. "
		\ -o '". shellescape(expand("%:r"). ".pdf"). "'"
endfunction

command MdToPdf call MdToPdf()