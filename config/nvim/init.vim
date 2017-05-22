" plugins

call plug#begin()

"" color

Plug 'cocopon/iceberg.vim'

"" misc

Plug 'Chiel92/vim-autoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
Plug 'justinmk/vim-sneak'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'plasticboy/vim-markdown'
Plug 'raviqqe/vim-non-blank'
Plug 'raviqqe/vim-pastplace'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/vim-auto-save'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'

"" fuzzy finder

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

"" language

Plug 'ElmCast/elm-vim'
Plug 'fatih/vim-hclfmt'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'JuliaLang/julia-vim'
Plug 'leafgarland/typescript-vim'
Plug 'lervag/vimtex'
Plug 'neoclide/vim-jsx-improve'

""" python

Plug 'alfredodeza/pytest.vim'
Plug 'zchee/deoplete-jedi'

""" go

Plug 'fatih/vim-go'
Plug 'zchee/deoplete-go'

""" rust

Plug 'phildawes/racer'
Plug 'racer-rust/vim-racer'
Plug 'rust-lang-nursery/rustfmt'
Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'

"" deoplete

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

"" operators

Plug 'kana/vim-operator-user'
Plug 'emonkak/vim-operator-sort'

"" text objects

Plug 'kana/vim-textobj-user'
Plug 'bps/vim-textobj-python'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'thinca/vim-textobj-comment'

call plug#end()



" pure vim

augroup Rc
	autocmd!
augroup END

set ttyfast
set nolazyredraw
set nobackup
set nowritebackup
set swapfile
set visualbell
set tildeop
set wildmenu
set wildmode=full
filetype plugin indent on
autocmd Rc BufWinEnter * set mouse=

"" tab setting

set autoindent
set smartindent
set shiftround
set smarttab
set shiftwidth=2
set tabstop=2
set list

"" appearance

syntax on
set number
set relativenumber
set colorcolumn=80
set showmatch
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
autocmd Rc BufRead,BufNewFile *.jl set filetype=julia
autocmd Rc BufRead,BufNewFile *.tisp set filetype=tisp
autocmd Rc BufRead,BufNewFile *.ts set filetype=typescript
autocmd Rc FileType sh set filetype=zsh

"" keymaps

let g:mapleader = "\<space>"

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



" plugin settings

"" deoplete

let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"


"" deoplete-rust

let g:deoplete#sources#rust#racer_binary = $HOME . '/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path = $RUST_SRC_PATH


"" neosnippet

let g:neosnippet#enable_auto_clear_markers = 0
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = [
			\ '~/.config/nvim/snippets',
			\ '~/.config/nvim/plugged/vim-snippets/snippets']
imap <c-k> <plug>(neosnippet_expand_or_jump)
smap <c-k> <plug>(neosnippet_expand_or_jump)
xmap <c-k> <plug>(neosnippet_expand_target)


"" easymotion

nmap <leader>s <plug>(easymotion-s)
nmap <leader>/ <plug>(easymotion-sn)


"" sneak

nmap t <plug>Sneak_s
nmap T <plug>Sneak_S
xmap t <plug>Sneak_s
xmap T <plug>Sneak_S
omap t <plug>Sneak_s
omap T <plug>Sneak_S

let g:sneak#s_next = 1


"" auto-pairs

let g:AutoPairsMapCh = 0
let g:AutoPairsMapCR = 0


"" vimtex

let g:vimtex_view_method = 'mupdf'


"" elm-vim

let g:elm_format_autosave = 1


"" markdown

let g:vim_markdown_folding_disabled = 1


"" quickrun

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config.clojure = {'command' : 'clojure'}


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


"" airline

let g:airline_theme = 'bubblegum'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols = {}
let g:airline_symbols.branch = ''
let g:airline_symbols.crypt = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.notexists = ''
let g:airline_symbols.paste = ''
let g:airline_symbols.spell = ''
let g:airline_symbols.whitespace = ''


"" autoformat

autocmd Rc BufEnter,BufWinEnter,BufRead,BufNewFile *
			\ if &filetype == "" | set filetype=text | endif
autocmd Rc BufWrite * :Autoformat
autocmd Rc FileType
			\ diff,elm,gitrebase,markdown,sh,text,tisp,xdefaults,yaml,zsh
			\ let b:autoformat_autoindent = 0
let g:formatters_python = ['autopep8']
let g:formatters_javascript = ['standard_javascript']


"" ale

let g:ale_linters = {
			\ 'javascript' : ['standard'],
			\ 'python': ['flake8', 'pylint'],
			\ }
let g:ale_javascript_standard_options = '--global describe --global it'


"" auto-save

let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_silent = 1


"" colorscheme

colorscheme iceberg

highlight Normal      ctermbg=none
highlight NonText     ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight VertSplit   cterm=none ctermfg=240 ctermbg=240
