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

local options = {noremap = true}

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
  augroup Init
    autocmd!
  augroup end

  autocmd Init BufRead,BufNewFile *.ll set filetype=llvm
]], true)

-- Plugins

require('init.lualine')
require('init.null-ls')
require('init.nvim-cmp')
require('init.nvim-lspconfig')
require('init.nvim-treesitter')
require('init.telescope')

--- auto-save

vim.g.auto_save = true
vim.g.auto_save_in_insert_mode = false
vim.g.auto_save_silent = true

--- nvim-autopairs

require('nvim-autopairs').setup({})

--- vim-go

vim.g.go_fmt_autosave = false

--- hop.nvim

require('hop').setup()

vim.api.nvim_set_keymap('n', '<leader>s',
                        "<cmd>lua require('hop').hint_words()<cr>", {})

--- trim.nvim

require('trim').setup({})
