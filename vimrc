" plugins

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
Plugin 'jiangmiao/auto-pairs'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'taka84u9/unite-git'
Plugin 'ujihisa/unite-colorscheme'

call vundle#end()
filetype plugin on

"" fix tab size for vundle

let s:tabwidth=2
au FileType * let &l:tabstop = s:tabwidth
au FileType * let &l:shiftwidth = s:tabwidth
au FileType * let &l:softtabstop = s:tabwidth



" pure vim

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

"" keymaps

let mapleader = " "

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

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

"" disable bold fonts

if !has('gui_running')
  set t_md=
endif



" settings per plugin

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

let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#enable_fuzzy_completion = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#enable_auto_close_preview = 1

""" delimiters

if !exists('g:neocomplete#delimiter_patterns')
  let g:neocomplete#delimiter_patterns = {}
endif

let g:neocomplete#delimiter_patterns.vim = ['#']
let g:neocomplete#delimiter_patterns.cpp = ['::']
let g:neocomplete#delimiter_patterns.python = ['.']

""" keywords

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif

let g:neocomplete#keyword_patterns._ = '\h\w*'

""" omni completion

autocmd Filetype *
  \ if &omnifunc == "" |
  \   setlocal omnifunc=syntaxcomplete#Complete |
  \ endif
autocmd Filetype css setlocal omnifunc=csscomplete#CompleteCSS
autocmd Filetype html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd Filetype javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd Filetype xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd Filetype python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

""" keymaps

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"


"" nerdtree

map <C-a> :NERDTree<CR>


"" easymotion

map <Leader><Leader>s <Plug>(easymotion-s2)
map <Leader><Leader>/ <Plug>(easymotion-sn)


"" unite

command Mapping Unite output:map|map!|lmap
nnoremap <Leader>us :Unite source<CR>
nnoremap <Leader>ub :Unite buffer<CR>
nnoremap <Leader>ufc :Unite file<CR>
nnoremap <Leader>ufr :Unite file_rec<CR>
nnoremap <Leader>ufm :Unite file_mru<CR>
