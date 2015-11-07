set encoding=utf-8

syntax on

set number
set nobackup
set nowritebackup

" tab setting

set expandtab     " expands tabs to spaces
set tabstop=2     " width of tabs
set shiftwidth=2  " width of tabs as auto indent
set softtabstop=2 " width of movement of curor for groups of spaces

set list
set listchars=tab:^I
set colorcolumn=80
set hlsearch

autocmd BufRead,BufNewFile *.sh set filetype=zsh
autocmd BufWritePre * :%s/\s\+$//e
