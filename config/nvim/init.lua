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

vim.diagnostic.config({ virtual_text = true })

vim.filetype.add({
	extension = {
		mdx = "markdown.mdx",
	},
	pattern = {
		[".*%.ll"] = { "llvm", { priority = 10 } },
	},
})

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

local group = vim.api.nvim_create_augroup("Init", {})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = group,
	pattern = { "*" },
	command = ":w",
	nested = true,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group,
	pattern = { "qf" },
	callback = function()
		vim.opt.winheight = math.min(vim.api.nvim_buf_line_count(0), 20)
	end,
})

-- Plugins

require("init.cmp")
require("init.hop")
require("init.lsp")
require("init.lualine")
require("init.telescope")
require("init.treesitter")

require("colorizer").setup()
require("ibl").setup()
require("lsp_signature").setup({ hint_prefix = "" })
require("nvim-autopairs").setup({})
require("trim").setup({})
