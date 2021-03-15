# vim-MdToPdf
A Vim plugin utilizing Pandoc and WeasyPrint to convert Markdown documents into PDF files, supporting LaTeX math input via KaTeX.

## Usage
When in a Markdown document, enter normal mode and type `:MdToPdf` to place a PDF of the Markdown document in the same directory, with the same name.

Running the command the first time may take a few minutes, depending on your internet connection, as a Chromium binary used to render JavaScript may need to be downloaded.

## Installation

### Dependencies
- Python 3
- A version of Vim compiled with Python 3 support (run `vim --version` to check this, if you see `+python3`, you're good)
- The `lxml` Python module
- The `pyppeteer` Python module
- [WeasyPrint](https://weasyprint.org/)
- [vim-pandoc](https://github.com/vim-pandoc/vim-pandoc)

Clone the repo to the `pack/plugins/start/vim-MdToPdf` directory in your `.vim` folder. If you have another way of installing Vim plugins that you like to use, that'll probably work with this plugin too, however this is untested.

## Configuration
The plugin provides one global variable that you can redefine in your `.vimrc` file:
- `g:vim_mdtopdf_cssurl`: Used to define a path or URL for custom CSS (uses my own personal CSS file by default, which is a slight modification of the CSS that Microsoft uses for Markdown in VS Code)
    * You can also use this CSS file to specify your paper size, if you want to use something other than Letter paper
