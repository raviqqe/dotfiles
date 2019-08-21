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
Plug 'sbdchd/neoformat'
Plug 'terryma/vim-multiple-cursors'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'

"" fuzzy finder

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

"" language

Plug 'alfredodeza/pytest.vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'sh install.sh' }
Plug 'fatih/vim-go'
Plug 'fatih/vim-hclfmt'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
Plug 'rhysd/vim-llvm'
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

"" deoplete

Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim'

call plug#end()


" pure vim

augroup Rc
	autocmd!
augroup END

set autochdir
set autoread
set hidden " for LanguageClient-neovim
set nobackup
set nolazyredraw
set nowritebackup
set swapfile
set tildeop
set ttyfast
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
set completeopt=menu
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

"" deoplete

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"


"" LanguageClient-neovim

let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
	\ 'c': ['clangd'],
	\ 'cpp': ['clangd'],
	\ 'go': ['go-langserver', '-gocodecompletion', '-usebinarypkgcache'],
	\ 'javascript': ['javascript-typescript-stdio'],
	\ 'javascript.jsx': ['javascript-typescript-stdio'],
	\ 'typescript': ['typescript-language-server', '--stdio'],
	\ 'typescript.jsx': ['typescript-language-server', '--stdio'],
	\ 'typescript.tsx': ['typescript-language-server', '--stdio'],
	\ 'python': ['pyls'],
	\ 'rust': ['rls'],
	\ }
let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_windowLogMessageLevel = 'Error'
nnoremap <leader>m :call LanguageClient_contextMenu()<cr>
nnoremap <leader>d :call LanguageClient#textDocument_definition()<cr>
nnoremap <leader>e :call LanguageClient#textDocument_references()<cr>
nnoremap <leader>n :call LanguageClient#textDocument_rename()<cr>


"" neosnippet

let g:neosnippet#enable_auto_clear_markers = 0
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = [
	\ '~/.config/nvim/snippets',
	\ '~/.config/nvim/plugged/vim-snippets/snippets',
	\ ]
imap <c-s> <plug>(neosnippet_expand_or_jump)
smap <c-s> <plug>(neosnippet_expand_or_jump)
xmap <c-s> <plug>(neosnippet_expand_target)


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


"" nvim-typescript

let g:nvim_typescript#diagnostics_enable = 0


"" vue

let g:vue_disable_pre_processors = 1


"" lightline

let g:lightline = { 'colorscheme': 'iceberg' }


"" colorscheme

colorscheme iceberg

highlight Normal      ctermbg=none
highlight NonText     ctermbg=none
highlight EndOfBuffer ctermbg=none
