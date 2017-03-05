" plugins

call plug#begin()

"" color

Plug 'cocopon/iceberg.vim'

"" misc

Plug 'Chiel92/vim-autoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
Plug 'neomake/neomake'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'raviqqe/vim-non-blank'
Plug 'raviqqe/vim-pastplace'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/vim-auto-save'
Plug 'wellle/targets.vim'

"" fuzzy finder

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"" language

Plug 'alfredodeza/pytest.vim'
Plug 'ElmCast/elm-vim'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'JuliaLang/julia-vim'
Plug 'lervag/vimtex'

""" go

Plug 'fatih/vim-go'
Plug 'zchee/deoplete-go'

""" rust

Plug 'phildawes/racer'
Plug 'racer-rust/vim-racer'
Plug 'rust-lang-nursery/rustfmt'
Plug 'rust-lang/rust.vim'

"" deoplete

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'zchee/deoplete-jedi'

"" operators

Plug 'kana/vim-operator-user'
Plug 'emonkak/vim-operator-comment'
Plug 'emonkak/vim-operator-sort'

"" text objects

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function' " only for vim
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'bps/vim-textobj-python'
Plug 'thinca/vim-textobj-comment'

call plug#end()



" pure vim

augroup DefaultAG
  autocmd!
augroup END

set encoding=utf-8
set nocompatible
set ttyfast
set lazyredraw
set nobackup
set nowritebackup
set swapfile
set visualbell
set tildeop
set wildmenu
set wildmode=full
filetype plugin indent on
autocmd BufEnter * set mouse=

"" tab setting

set autoindent
set smartindent
set shiftround
set smarttab

function s:set_2_space_tab()
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set list
  set listchars=tab:^I
endfunction

function s:set_soft_tab()
  set expandtab
  call s:set_2_space_tab()
endfunction

function s:set_hard_tab()
  set noexpandtab
  call s:set_2_space_tab()
endfunction

call s:set_soft_tab()

for thefiletype in ['vim', 'rust']
  exec 'autocmd DefaultAG FileType ' . thefiletype . ' call s:set_soft_tab()'
endfor

for thefiletype in ['make', 'neosnippet']
  exec 'autocmd DefaultAG FileType ' . thefiletype . ' call s:set_hard_tab()'
endfor

for thefiletype in ['go']
  exec 'autocmd DefaultAG FileType ' . thefiletype . ' set nolist'
endfor

"" appearance

syntax on
set number
set relativenumber
set colorcolumn=80
set showmode
set showcmd
set wrap
set inccommand=nosplit
set incsearch
set hlsearch
set splitbelow
set splitright
set cursorline
set backspace=indent,eol,start
set completeopt=menu
autocmd BufRead,BufNewFile *.sh set filetype=zsh
autocmd BufRead,BufNewFile *.jl set filetype=julia


"" keymaps

let mapleader = "\<space>"

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap gj j
nnoremap gk k
nnoremap <esc><esc> :nohlsearch<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap Q :q!<cr>
nnoremap Y y$

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



" plugin settings

"" deoplete

let g:acp_enableAtStartup = 0
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources#syntax#min_keyword_length = 3
let g:deoplete#enable_fuzzy_completion = 1
let g:deoplete#enable_auto_delimiter = 1
let g:deoplete#enable_auto_close_preview = 1

""" delimiters

if !exists('g:deoplete#delimiter_patterns')
  let g:deoplete#delimiter_patterns = {}
endif

let g:deoplete#delimiter_patterns.vim = ['#']
let g:deoplete#delimiter_patterns.cpp = ['::']
let g:deoplete#delimiter_patterns.python = ['.']

""" omni completion

autocmd FileType *
      \ if &omnifunc == "" |
      \   setlocal omnifunc=syntaxcomplete#Complete |
      \ endif
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType python setlocal omnifunc=python3complete#Complete
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

""" keymaps

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"


"" deoplete-rust

let g:deoplete#sources#rust#racer_binary = '/home/raviqqe/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path = $RUST_SRC_PATH


"" neosnippet

let g:neosnippet#snippets_directory = '~/.vim/snippets'
imap <c-k> <plug>(neosnippet_expand_or_jump)
smap <c-k> <plug>(neosnippet_expand_or_jump)
xmap <c-k> <plug>(neosnippet_expand_target)


"" nerdtree

nnoremap <c-a> :NERDTree<cr>

" close nerttree when it is the last and only buffer
autocmd bufenter * if (winnr("$") == 1
      \ && exists("b:NERDTree")
      \ && b:NERDTree.isTabTree())
      \ | q | endif


"" easymotion

nmap <leader>s <plug>(easymotion-s)
nmap <leader>/ <plug>(easymotion-sn)


"" auto-pairs

let g:AutoPairsMapCh = 0
let g:AutoPairsMapCR = 0


"" vimtex

let g:vimtex_view_method = 'mupdf'


"" elm-vim

let g:elm_format_autosave = 1


"" fzf

nnoremap <leader>b :Buffers<cr>
nnoremap <leader>c :History:<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>g :GFiles<cr>
nnoremap <leader>h :Helptags<cr>
nnoremap <leader>l :Lines<cr>
nnoremap <leader>m :Maps<cr>
nnoremap <leader>r :Ag<cr>
nnoremap <leader>u :History<cr>


"" autoformat

autocmd BufWrite *.py,*.vim,*.tex :Autoformat
let g:formatters_python = ['autopep8']


"" auto-save

let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_silent = 1


"" neomake

autocmd BufEnter,BufWritePost * Neomake

let g:neomake_error_sign = {'text': 'EE'}
let g:neomake_warning_sign = {'text': 'WW'}


"" colorscheme

colorscheme iceberg

for name in ['Error', 'Warning']
  let link = 'highlight link Neomake'.name
  exec link.' '.name.'Msg'
  exec link.'Sign icebergLL'.name
endfor

highlight Normal      ctermbg=none
highlight NonText     ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight VertSplit   cterm=none ctermfg=240 ctermbg=240


" Don't ruin the last register pasting its content in visual mode

function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction

vmap <silent> <expr> p <sid>Repl()
