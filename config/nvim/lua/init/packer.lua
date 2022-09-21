local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("airblade/vim-gitgutter")
	use("aserowy/tmux.nvim")
	use("b3nj5m1n/kommentary")
	use("cocopon/iceberg.vim")
	use("farmergreg/vim-lastplace")
	use("hoob3rt/lualine.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("maxbrunsfeld/vim-yankstack")
	use("NvChad/nvim-colorizer.lua")
	use("pbrisbin/vim-mkdir")
	use("rhysd/clever-f.vim")
	use("rlane/pounce.nvim")
	use("tpope/vim-abolish")
	use("tpope/vim-fugitive")
	use("tpope/vim-sleuth")
	use("tpope/vim-surround")
	use("windwp/nvim-autopairs")
	use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate all" })

	-- languages

	use("hashivim/vim-hashicorp-tools")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-emoji")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/nvim-cmp")
	use("L3MON4D3/LuaSnip")
	use("neovim/nvim-lspconfig")
	use("pen-lang/pen.vim")
	use("ray-x/cmp-treesitter")
	use("ray-x/lsp_signature.nvim")
	use("sheerun/vim-polyglot")
	use("styled-components/vim-styled-components")
	use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })

	-- GitHub Copilot

	use("github/copilot.vim")
	use({
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			vim.schedule(function()
				require("copilot").setup()
			end)
		end,
	})
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot-cmp").setup()
		end,
	})
end)
