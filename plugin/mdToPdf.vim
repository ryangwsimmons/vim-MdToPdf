function! MdToPdf()
    execute "Pandoc html
		\ --css https://cdn.jsdelivr.net/gh/ryangwsimmons/vim-MdToPdf/style/md-style.css
		\ --katex https://cdn.jsdelivr.net/npm/katex@latest/dist/
		\ -V margin-top=0.5in -V margin-bottom=0.5in -V margin-left=0.5in -V margin-right=0.5in
		\ -V papersize=letter
		\ -o '". shellescape(expand("%:r"). ".pdf"). "'"
endfunction

command MdToPdf call MdToPdf()
