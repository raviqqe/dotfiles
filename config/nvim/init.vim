" options

augroup Rc
  autocmd!
augroup end

set autochdir
set autoread
set clipboard+=unnamedplus
set completeopt=menuone,noselect
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
set shortmess+=c
set showcmd
set showmatch
set showmode
set splitbelow
set splitright
set wrap

autocmd Rc BufRead,BufNewFile *.jl set filetype=julia
autocmd Rc BufRead,BufNewFile *.ll set filetype=llvm
autocmd Rc BufRead,BufNewFile *.lua set filetype=lua
autocmd Rc BufRead,BufNewFile *.rules set filetype=text
autocmd Rc BufRead,BufNewFile *.ts set filetype=typescript
autocmd Rc BufRead,BufNewFile *.tsx set filetype=typescript.tsx
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

nnoremap d "*d
nnoremap D "*D
nnoremap dd "*dd
nnoremap p "*p
nnoremap x "*x
nnoremap yy "*yy
vnoremap p "*p
vnoremap y "*y


" plugins

lua require('init.packer')


"" nvim-lspconfig

lua require('init.nvim-lspconfig')

"" nvim-cmp

lua require('init.nvim-cmp')

autocmd Rc FileType qf nnoremap <buffer> <cr> <cr>:cclose<cr>
autocmd Rc FileType * lua require'cmp'.setup.buffer { sources = { { name = 'buffer' }, { name = 'nvim_lsp' } } }


"" nvim-treesitter

lua require('init.nvim-treesitter')


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

let g:ale_linters = {
  \ 'typescript': ['eslint', 'tslint'],
  \ }
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

let g:neoformat_toml_prettier = {
  \ 'exe': 'prettier',
  \ 'args': ['--parser', 'toml'],
  \ 'stdin': 1,
  \ }

let g:neoformat_enabled_toml = ['prettier']

let g:neoformat_rust_rustfmt = {
  \ 'exe': 'rustfmt',
  \ 'stdin': 1,
  \ }

let g:neoformat_jsonc_prettier = {
  \ 'exe': 'prettier',
  \ 'args': ['--parser', 'json'],
  \ 'stdin': 1,
  \ }

let g:neoformat_enabled_jsonc = ['prettier']


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
