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
Plug 'mattn/webapi-vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'pbrisbin/vim-mkdir'
Plug 'rhysd/clever-f.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

"" fuzzy finder

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

"" languages

Plug 'ap/vim-css-color'
Plug 'ein-lang/ein.vim'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'pen-lang/pen.vim'
Plug 'sbdchd/neoformat'
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'w0rp/ale'

call plug#end()


" pure vim

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


" plugin settings

"" neovim-lspconfig

lua << EOF
local lsp = require('lspconfig')

local on_attach = function(client, buffer)
  local keymap = function(key, command)
    vim.api.nvim_buf_set_keymap(buffer, 'n', key, command, { noremap = true, silent = true })
  end

  keymap('<leader>d', '<cmd>lua vim.lsp.buf.definition()<cr>')
  keymap('<leader>e', '<cmd>lua vim.lsp.buf.references()<cr>')
  keymap('<leader>n', '<cmd>lua vim.lsp.buf.rename()<cr>')
  keymap('<leader>t', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
  keymap('<leader>y', '<cmd>lua vim.lsp.buf.implementation()<cr>')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

for _, command in ipairs({ "gopls", "rust_analyzer", "tsserver" }) do
  lsp[command].setup { capabilities = capabilities, on_attach = on_attach }
end
EOF


"" nvim-compe

lua << EOF
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  min_length = 1,
  preselect = 'enable',
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
  },
}
EOF

inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <silent><expr> <cr> compe#confirm('<cr>')

autocmd Rc FileType qf nnoremap <buffer> <cr> <cr>:cclose<cr>


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
