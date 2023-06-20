local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		"--branch=stable",
		path,
	})
end

vim.opt.rtp:prepend(path)

require("lazy").setup({
	"airblade/vim-gitgutter",
	"aserowy/tmux.nvim",
	"b3nj5m1n/kommentary",
	"cappyzawa/trim.nvim",
	"cocopon/iceberg.vim",
	"farmergreg/vim-lastplace",
	"hoob3rt/lualine.nvim",
	{
		"jackMort/ChatGPT.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	"jose-elias-alvarez/null-ls.nvim",
	"lukas-reineke/indent-blankline.nvim",
	"maxbrunsfeld/vim-yankstack",
	"NvChad/nvim-colorizer.lua",
	"pbrisbin/vim-mkdir",
	"phaazon/hop.nvim",
	"rhysd/clever-f.vim",
	"tpope/vim-abolish",
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"windwp/nvim-autopairs",
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate all" },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	-- Languages

	"hashivim/vim-hashicorp-tools",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-emoji",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/nvim-cmp",
	"hrsh7th/vim-vsnip",
	"neovim/nvim-lspconfig",
	"pen-lang/pen.vim",
	"ray-x/cmp-treesitter",
	"ray-x/lsp_signature.nvim",
	"styled-components/vim-styled-components",

	-- GitHub Copilot

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			vim.schedule(function()
				require("copilot").setup()
			end)
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
})
