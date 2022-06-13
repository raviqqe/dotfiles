require("init.packer")

-- General

vim.opt.autochdir = true
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.clipboard = vim.opt.clipboard + { "unnamedplus" }
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.hidden = true
vim.opt.lazyredraw = true
vim.opt.swapfile = true
vim.opt.tildeop = true
vim.opt.ttyfast = true
vim.opt.updatetime = 500
vim.opt.visualbell = true
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
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

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = true

vim.cmd([[
	filetype plugin indent on
	syntax on

	colorscheme iceberg

	highlight Normal ctermbg=none
	highlight NonText ctermbg=none
	highlight EndOfBuffer ctermbg=none
]])

-- Keymaps

vim.g.mapleader = " "

local options = { noremap = true }

vim.keymap.set("n", ";", ":", options)
vim.keymap.set("n", ":", ";", options)
vim.keymap.set("v", ";", ":", options)
vim.keymap.set("v", ":", ";", options)

vim.keymap.set("n", "<leader>w", ":w<cr>", options)
vim.keymap.set("n", "<leader>q", ":q<cr>", options)

for _, mode in ipairs({ "n", "v" }) do
	vim.keymap.set(mode, "j", "v:count ? 'j' : 'gj'", { expr = true, noremap = true })
	vim.keymap.set(mode, "k", "v:count ? 'k' : 'gk'", { expr = true, noremap = true })
	vim.keymap.set(mode, "gj", "j", options)
	vim.keymap.set(mode, "gk", "k", options)
end

vim.keymap.set("n", "Q", ":q!<cr>", options)
vim.keymap.set("n", "Y", "y$", options)
vim.keymap.set("n", "<esc><esc>", ":nohlsearch<cr>", options)

vim.keymap.set("i", "<c-h>", "<left>", options)
vim.keymap.set("i", "<c-j>", "<down>", options)
vim.keymap.set("i", "<c-k>", "<up>", options)
vim.keymap.set("i", "<c-l>", "<right>", options)

vim.keymap.set("c", "<c-h>", "<left>", options)
vim.keymap.set("c", "<c-j>", "<c-n>", options)
vim.keymap.set("c", "<c-k>", "<c-p>", options)
vim.keymap.set("c", "<c-l>", "<right>", options)

-- Autocmd

local group = "Init"

vim.api.nvim_create_augroup(group, {})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = group,
	pattern = { "*.astro" },
	callback = function()
		vim.opt.filetype = "astro"
	end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = group,
	pattern = { "*.ll" },
	callback = function()
		vim.opt.filetype = "llvm"
	end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	group = group,
	pattern = { "*" },
	command = ":w",
	nested = true,
})

-- Plugins

require("init.cmp")
require("init.lspconfig")
require("init.lualine")
require("init.telescope")
require("init.treesitter")

require("kommentary.config").configure_language("default", {
	prefer_single_line_comments = true,
})
require("nvim-autopairs").setup({})
require("tmux").setup({
	copy_sync = { enable = true },
	navigation = { enable_default_keybindings = true },
})

--- auto-save

vim.g.auto_save = true
vim.g.auto_save_in_insert_mode = false
vim.g.auto_save_silent = true

--- copilot

vim.g.copilot_no_tab_map = true
vim.g.copilot_node_command = "~/.homebrew/opt/node@16/bin/node"

--- vim-go

vim.g.go_fmt_autosave = false

--- hop.nvim

local hop = require("hop")

hop.setup()

vim.keymap.set("n", "<leader>s", hop.hint_words)
