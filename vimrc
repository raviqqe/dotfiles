" plugins

call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'altercation/vim-colors-solarized'
Plug 'nathanaelkane/vim-indent-guides'

"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim',
  \ { 'do': 'if which gmake; then gmake; else make; fi' }
Plug 'Shougo/unite.vim'
Plug 'Shougo/neoyank.vim'
Plug 'thinca/vim-unite-history'
Plug 'taka84u9/unite-git'
Plug 'ujihisa/unite-colorscheme'
Plug 'tsukkee/unite-help'
Plug 'junegunn/fzf'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()



" pure vim

set encoding=utf-8
set nocompatible
set ttyfast
set lazyredraw
set nobackup
set nowritebackup
set swapfile
filetype plugin indent on
autocmd BufWritePre * :%s/\s\+$//e

"" viminfo

if has('nvim')
  set viminfo='16,\"128,:32,%,n~/.cache/nvim/nviminfo
else
  set viminfo='16,\"128,:32,%,n~/.viminfo
endif

function! RestoreCursor()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup restoreCursor
  autocmd!
  autocmd BufWinEnter * call RestoreCursor()
augroup END

"" tab setting

set expandtab     " expands tabs to spaces
set tabstop=2     " width of tabs
set shiftwidth=2  " width of tabs as auto indent
set softtabstop=2 " width of movement of curor for groups of spaces
set list
set listchars=tab:^I
set autoindent
set shiftround

"" appearance

syntax on
set number
set background=dark
set colorcolumn=80
set showmode
set showcmd
set wrap
set incsearch
set hlsearch
set splitbelow
set splitright
set cursorline
set backspace=indent,eol,start
set completeopt=menu
autocmd BufRead,BufNewFile *.sh set filetype=zsh

let term=$TERM
if term =~ '256color'
  let g:solarized_termcolors=256
  colorscheme solarized
else
  colorscheme default
endif

""" disable bold fonts

if !has('gui_running')
  set t_md=
endif

"" keymaps

let mapleader = "\<space>"

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <esc><esc> :nohlsearch<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap Q :q!

inoremap <c-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>

cnoremap <c-h> <left>
cnoremap <c-j> <c-n>
cnoremap <c-k> <c-p>
cnoremap <c-l> <right>

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



" settings per plugin

"" vim-indent-guides

let g:indent_guides_enable_on_vim_startup = 0
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey


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

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"


"" nerdtree

nnoremap <c-a> :NERDTree<cr>


"" easymotion

nnoremap <leader>s <plug>(easymotion-s)
nnoremap <leader>/ <plug>(easymotion-sn)


"" auto-pairs

let g:AutoPairsMapCh = 0


"" unite

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('grep', 'matchers', 'matcher_fuzzy')
let g:unite_enable_start_insert = 1
let g:unite_source_history_enable = 1
let g:unite_matcher_fuzzy_max_input_length = 256
let g:unite_prompt = '> '
let g:unite_ignore_case = 1

let grep_alternative = 'pt'
if executable(grep_alternative)
  let g:unite_source_grep_command = grep_alternative
  let g:unite_source_rec_async_command = grep_alternative
                                         \ . ' --nocolor --nogroup -g .'
  let g:unite_source_grep_default_opts = '--nocolor --nogroup'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_encoding = 'utf-8'
endif

command Mapping Unite output:map|map!|lmap
nnoremap <leader>a :Unite source<cr>
nnoremap <leader>b :Unite buffer<cr>
nnoremap <leader>f :Unite file<cr>
nnoremap <leader>r :Unite file_rec<cr>
nnoremap <leader>m :Unite file_mru<cr>
nnoremap <leader>h :Unite help<cr>
nnoremap <leader>g :execute 'Unite grep:' . getcwd()<cr>
nnoremap <leader>y :Unite history/yank<cr>
nnoremap <leader>c :Unite history/command<cr>


" Don't ruin the last register pasting its content in visual mode

function RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction

vmap <silent> <expr> p <sid>Repl()
