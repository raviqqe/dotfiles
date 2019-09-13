" plugins

call plug#begin()

Plug '907th/vim-auto-save'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'cocopon/iceberg.vim'
Plug 'easymotion/vim-easymotion'
Plug 'farmergreg/vim-lastplace'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'pbrisbin/vim-mkdir'
Plug 'rhysd/clever-f.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

"" fuzzy finder

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

"" language

Plug 'fatih/vim-go'
Plug 'fatih/vim-hclfmt'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'neoclide/coc-rls', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-tsserver', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'sbdchd/neoformat'
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'w0rp/ale'

call plug#end()


" pure vim

augroup Rc
	autocmd!
augroup END

set autochdir
set autoread
set completeopt+=noinsert,noselect
set hidden
set nobackup
set nolazyredraw
set nowritebackup
set swapfile
set tildeop
set ttyfast
set updatetime=500
set visualbell
set wildmenu
set wildmode=full

filetype plugin indent on

autocmd Rc BufWinEnter * set mouse=

"" space setting

set autoindent
set list
set shiftround
set shiftwidth=2
set smartindent
set smarttab
set tabstop=2

"" appearance

syntax on

set backspace=indent,eol,start
set colorcolumn=80
set cursorline
set hlsearch
set inccommand=nosplit
set incsearch
set number
set relativenumber
set shortmess=a
set showcmd
set showmatch
set showmode
set splitbelow
set splitright
set wrap

autocmd Rc BufRead,BufNewFile *.jl set filetype=julia
autocmd Rc BufRead,BufNewFile *.lua set filetype=lua
autocmd Rc BufRead,BufNewFile *.rules set filetype=text
autocmd Rc BufRead,BufNewFile *.ts set filetype=typescript
autocmd Rc FileType sh set filetype=zsh

"" keymaps

let g:mapleader = ' '

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

"" coc.nvim

inoremap <expr><cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

nmap <leader>d <plug>(coc-definition)
nmap <leader>e <plug>(coc-references)
nmap <leader>n <plug>(coc-rename)
nmap <leader>t <plug>(coc-type-definition)
nmap <leader>y <plug>(coc-implementations)


"" auto-pairs

let g:AutoPairsMapCh = 0
let g:AutoPairsMapCR = 0


"" fzf

command! -bang -nargs=* RgGlobal
	\ call fzf#vim#grep(
		\ 'rg --column --no-heading --color=always --smart-case '.shellescape(<q-args>),
		\ 1,
		\ { 'dir': systemlist('git rev-parse --show-toplevel')[0] },
		\ <bang>0)

nnoremap <leader>b :Buffers<cr>
nnoremap <leader>c :History:<cr>
nnoremap <leader>f :Files!<cr>
nnoremap <leader>g :Rg!<cr>
nnoremap <leader>a :RgGlobal!<cr>
nnoremap <leader>h :History!<cr>
nnoremap <leader>l :Lines!<cr>
nnoremap <leader>r :GitFiles!<cr>


"" easymotion

let g:EasyMotion_do_mapping = 0
nmap <leader>s <plug>(easymotion-overwin-w)


"" ale

let g:ale_fixers = {
	\ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\ 'typescript': ['eslint', 'tslint'],
	\ }
let g:ale_fix_on_save = 1


"" neoformat

autocmd Rc BufWritePre * silent! undojoin | Neoformat

let g:neoformat_only_msg_on_error = 1

let g:neoformat_zsh_shfmt = {
	\ 'exe': 'shfmt',
	\ 'args': ['-i ' . shiftwidth()],
	\ 'stdin': 1,
	\ }

let g:neoformat_enabled_zsh = ['shfmt']


"" auto-save

let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_silent = 1


"" vim-go

let g:go_fmt_autosave = 0


"" vue

let g:vue_disable_pre_processors = 1


"" lightline

let g:lightline = { 'colorscheme': 'iceberg' }


"" colorscheme

colorscheme iceberg

highlight Normal      ctermbg=none
highlight NonText     ctermbg=none
highlight EndOfBuffer ctermbg=none

highlight CocErrorSign ctermfg=Red ctermbg=235
highlight CocWarningSign ctermfg=Brown ctermbg=235
highlight CocInfoSign ctermfg=Yellow ctermbg=235
highlight CocHintSign ctermfg=Blue ctermbg=235
