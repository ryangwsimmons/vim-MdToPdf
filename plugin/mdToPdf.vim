" Define plugin default values, if not re-defined by user
if !exists("g:vim_mdtopdf_cssurl")
    let g:vim_mdtopdf_cssurl = "https://cdn.jsdelivr.net/gh/ryangwsimmons/vim-MdToPdf@master/style/md-style.css"
endif

if !exists("g:vim_mdtopdf_papersize")
    let g:vim_mdtopdf_papersize = "letter"
endif

function! MdToPdf()
    lcd %:p:h
    execute "Pandoc html
        \ --standalone
        \ --pdf-engine-opt=\"--enable-local-file-access\"
		\ --css ". g:vim_mdtopdf_cssurl. "
		\ -H https://cdn.jsdelivr.net/gh/ryangwsimmons/vim-MdToPdf@master/html-includes/html-includes.html
		\ -V margin-top=0.5in -V margin-bottom=0.5in -V margin-left=0.5in -V margin-right=0.5in
		\ -V papersize=". g:vim_mdtopdf_papersize. "
		\ -o '". shellescape(expand("%:r"). ".html"). "'"
endfunction

command MdToPdf call MdToPdf()
