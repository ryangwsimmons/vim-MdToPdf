# vim-MdToPdf
A Vim plugin utilizing Pandoc and wkhtmltopdf to convert Markdown documents into PDF files, supporting LaTeX math input via KaTeX.

## Usage
When in a Markdown document, enter normal mode and type `:MdToPdf` to place a PDF of the Markdown document in the same directory, with the same name.

## Installation

### Dependencies
- [wkhtmltopdf](https://wkhtmltopdf.org/)
- [vim-pandoc](https://github.com/vim-pandoc/vim-pandoc)

Clone the repo to the `pack/vendor/start/vim-MdToPdf` directory in your `.vim` folder. If you have another way of installing Vim plugins that you like to use, that'll probably work with this plugin too, however this is untested.

## Configuration
The plugin provides two global variables that you can redefine in your `.vimrc` file:
- `g:vim_mdtopdf_cssurl`: Used to define a custom path or URL for custom CSS (uses my own personal CSS file by default, which is a slight modification of Microsoft's CSS which is used for Markdown in VS Code).
- `g:vim_mdtopdf_papersize`: Used to set a custom paper size (Letter by default),
