require('init.packer')

-- General

vim.opt.autochdir = true
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.clipboard = vim.opt.clipboard + {'unnamedplus'}
vim.opt.completeopt = {'menuone', 'noselect'}
vim.opt.hidden = true
vim.opt.lazyredraw = true
vim.opt.swapfile = true
vim.opt.tildeop = true
vim.opt.ttyfast = true
vim.opt.updatetime = 500
vim.opt.visualbell = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'
vim.opt.writebackup = false

-- Spacing

vim.opt.autoindent = true
vim.opt.list = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2

-- Appearance

vim.opt.backspace = {'indent', 'eol', 'start'}
vim.opt.colorcolumn = '80'
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'nosplit'
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess = vim.opt.shortmess + {c = true}
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = true

vim.api.nvim_exec([[
  filetype plugin indent on
  syntax on

  colorscheme iceberg

  highlight Normal      ctermbg=none
  highlight NonText     ctermbg=none
  highlight EndOfBuffer ctermbg=none
]], true)

-- Kepmaps

vim.g.mapleader = ' '

options = {noremap = true}

vim.api.nvim_set_keymap('n', ';', ':', options)
vim.api.nvim_set_keymap('n', ':', ';', options)
vim.api.nvim_set_keymap('v', ';', ':', options)
vim.api.nvim_set_keymap('v', ':', ';', options)

vim.api.nvim_set_keymap('n', '<leader>w', ':w<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>q', ':q<cr>', options)

vim.api.nvim_set_keymap('n', 'j', "v:count ? 'j' : 'gj'",
                        {expr = true, noremap = true})
vim.api.nvim_set_keymap('n', 'k', "v:count ? 'k' : 'gk'",
                        {expr = true, noremap = true})
vim.api.nvim_set_keymap('n', 'gj', 'j', options)
vim.api.nvim_set_keymap('n', 'gk', 'k', options)

vim.api.nvim_set_keymap('n', 'Q', ':q!<cr>', options)
vim.api.nvim_set_keymap('n', 'Y', 'y$', options)
vim.api.nvim_set_keymap('n', '<esc><esc>', ':nohlsearch<cr>', options)

vim.api.nvim_set_keymap('i', '<c-h>', '<left>', options)
vim.api.nvim_set_keymap('i', '<c-j>', '<down>', options)
vim.api.nvim_set_keymap('i', '<c-k>', '<up>', options)
vim.api.nvim_set_keymap('i', '<c-l>', '<right>', options)

vim.api.nvim_set_keymap('c', '<c-h>', '<left>', options)
vim.api.nvim_set_keymap('c', '<c-j>', '<c-n>', options)
vim.api.nvim_set_keymap('c', '<c-k>', '<c-p>', options)
vim.api.nvim_set_keymap('c', '<c-l>', '<right>', options)

-- Autocmd

vim.api.nvim_exec([[
  augroup Rc
    autocmd!
  augroup end

  autocmd Rc BufRead,BufNewFile *.jl set filetype=julia
  autocmd Rc BufRead,BufNewFile *.ll set filetype=llvm
  autocmd Rc BufRead,BufNewFile *.lua set filetype=lua
  autocmd Rc BufRead,BufNewFile *.rules set filetype=text
  autocmd Rc BufRead,BufNewFile *.ts set filetype=typescript
  autocmd Rc BufRead,BufNewFile *.tsx set filetype=typescript.tsx
  autocmd Rc FileType sh set filetype=zsh
]], true)

-- Plugins

require('init.lualine')
require('init.nvim-cmp')
require('init.nvim-lspconfig')
require('init.nvim-treesitter')

--- auto-save

vim.g.auto_save = true
vim.g.auto_save_in_insert_mode = false
vim.g.auto_save_silent = true

--- auto-pairs

vim.g.AutoPairsMapCh = false
vim.g.AutoPairsMapCR = false

--- neoformat

vim.api.nvim_exec([[autocmd Rc BufWritePre * silent! undojoin | Neoformat]],
                  true)

vim.g.neoformat_only_msg_on_error = true

--- ale

vim.g.ale_linters = {typescript = {'eslint'}}
vim.g.ale_fixers = {
    ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
    typescript = {'eslint'}
}
vim.g.ale_fix_on_save = 1

--- vim-go

vim.g.go_fmt_autosave = false

--- easymotion

vim.g.EasyMotion_do_mapping = false
vim.api.nvim_set_keymap('n', '<leader>s', '<plug>(easymotion-overwin-w)', {})

--- fzf

vim.api.nvim_exec([[
command! -bang -nargs=* RgGlobal
  \ call fzf#vim#grep(
    \ 'rg --column --no-heading --color=always --smart-case '.shellescape(<q-args>),
    \ 1,
    \ { 'dir': systemlist('git rev-parse --show-toplevel')[0] },
    \ <bang>0)
]], true)

vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>c', ':History:<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>f', ':Files!<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>g', ':Rg!<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>a', ':RgGlobal!<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>h', ':History!<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>l', ':Lines!<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>r', ':GitFiles!<cr>', options)
