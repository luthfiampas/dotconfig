syntax enable

call plug#begin()

Plug 'tomasiser/vim-code-dark'
Plug 'tribela/vim-transparent'
Plug 'itmammoth/doorboy.vim'
Plug 'tpope/vim-surround'

call plug#end()

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set number relativenumber
set ignorecase

colorscheme codedark
