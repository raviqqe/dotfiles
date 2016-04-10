" vundle

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'flazz/vim-colorschemes'
Plugin 'altercation/vim-colors-solarized.git'
Plugin 'nathanaelkane/vim-indent-guides'

"Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-commentary'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'easymotion/vim-easymotion'
Plugin 'Shougo/neocomplete.vim'

call vundle#end()
filetype plugin on

"" fix tab size for vundle

let s:tabwidth=2
au FileType * let &l:tabstop = s:tabwidth
au FileType * let &l:shiftwidth = s:tabwidth
au FileType * let &l:softtabstop = s:tabwidth



" my preferences

set encoding=utf-8

syntax on

set nocompatible
set number
set nobackup
set nowritebackup

"" tab setting

set expandtab     " expands tabs to spaces
set tabstop=2     " width of tabs
set shiftwidth=2  " width of tabs as auto indent
set softtabstop=2 " width of movement of curor for groups of spaces

set list
set listchars=tab:^I
set colorcolumn=80
set hlsearch
set backspace=indent,eol,start

set background=dark
colorscheme default

autocmd BufRead,BufNewFile *.sh set filetype=zsh
autocmd BufWritePre * :%s/\s\+$//e

"" disable bold fonts

if !has('gui_running')
  set t_md=
endif

"" vim-indent-guides

let g:indent_guides_start_level=2
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=lightgrey

"" YouCompleteMe

let g:ycm_autoclose_preview_window_after_insertion = 1

" Do not display "Pattern not found" during YouCompleteMe completion

try
  set shortmess+=c
catch /E539: Illegal character/
endtry

"" neocomplete

let g:neocomplete#enable_at_startup = 1

"" commands

cnoreabbrev Wc wincmd

function! s:Prefix(prefix, name)
  try
    execute ':%s/\(' . a:name . '\)/' . a:prefix . '\1/gc'
  catch /E486: Pattern not found/
    echom "Pattern not found!"
  endtry
endfunction

command -nargs=* Prefix call s:Prefix(<f-args>)

"" keymaps

let mapleader = " "

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

map <C-a> :NERDTree<CR>
map <Leader><Leader>s <Plug>(easymotion-s2)
map <Leader><Leader>/ <Plug>(easymotion-sn)
