require("init.lazy")

-- General

vim.opt.cmdheight = 0
vim.opt.autochdir = true
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.clipboard = vim.opt.clipboard + { "unnamedplus" }
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.lazyredraw = true
vim.opt.smartcase = true
vim.opt.swapfile = true
vim.opt.tildeop = true
vim.opt.ttyfast = true
vim.opt.updatetime = 500
vim.opt.visualbell = true
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.writebackup = false

vim.loader.enable()

-- Spacing

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Appearance

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess = vim.opt.shortmess + { c = true, F = false }
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = true

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.diagnostic.config({ virtual_text = true })

vim.filetype.add({
  extension = {
    daml = "haskell",
    mdx = "markdown.mdx",
    ll = "llvm",
  },
})

-- Keymaps

vim.g.mapleader = " "

local function set_keymap(mode, from, to)
  vim.keymap.set(mode, from, to, { noremap = true, silent = true })
end

set_keymap("n", ";", ":")
set_keymap("n", ":", ";")
set_keymap("v", ";", ":")
set_keymap("v", ":", ";")

set_keymap("n", "<leader>w", ":w<cr>")
set_keymap("n", "<leader>q", ":q<cr>")

for _, mode in ipairs({ "n", "v" }) do
  vim.keymap.set(mode, "j", "v:count ? 'j' : 'gj'", { expr = true, noremap = true })
  vim.keymap.set(mode, "k", "v:count ? 'k' : 'gk'", { expr = true, noremap = true })
  set_keymap(mode, "gj", "j")
  set_keymap(mode, "gk", "k")
end

set_keymap("n", "Q", ":q!<cr>")
set_keymap("n", "Y", "y$")
set_keymap("n", "<esc><esc>", ":nohlsearch<cr>")

set_keymap("i", "<c-h>", "<left>")
set_keymap("i", "<c-j>", "<down>")
set_keymap("i", "<c-k>", "<up>")
set_keymap("i", "<c-l>", "<right>")

set_keymap("c", "<c-h>", "<left>")
set_keymap("c", "<c-j>", "<c-n>")
set_keymap("c", "<c-k>", "<c-p>")
set_keymap("c", "<c-l>", "<right>")

set_keymap("v", "p", "P")

-- Autocmd

local group = vim.api.nvim_create_augroup("Init", {})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  pattern = { "*" },
  nested = true,
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "" then
      vim.cmd("write")
    end
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group,
  pattern = { "qf" },
  callback = function()
    vim.opt.winheight = math.min(vim.api.nvim_buf_line_count(0), 20)
  end,
})

-- Plugins

require("init.avante")
require("init.cmp")
require("init.fuzzy")
require("init.hop")
require("init.lsp")
require("init.lualine")
require("init.tmux")
require("init.treesitter")

require("automkdir").setup()
require("colorizer").setup()
require("ibl").setup()
require("lastplace").setup()
require("lsp_signature").setup({ hint_prefix = "" })
require("nvim-autopairs").setup({})
require("nvim-surround").setup({})
require("trim").setup({})
require('gitsigns').setup()
