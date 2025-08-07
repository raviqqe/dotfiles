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
  "cappyzawa/trim.nvim",
  "christoomey/vim-tmux-navigator",
  "farmergreg/vim-lastplace",
  "hoob3rt/lualine.nvim",
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
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-context",
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
  "hrsh7th/nvim-cmp",
  "neovim/nvim-lspconfig",
  "pen-lang/pen.vim",
  "ray-x/cmp-treesitter",
  "ray-x/lsp_signature.nvim",

  -- AI 🤖

  {
    "zbirenbaum/copilot.lua",
    config = function()
      vim.schedule(function()
        require("copilot").setup({
          filetypes = {
            markdown = true,
          },
          server = {
            type = "nodejs",
          },
        })
      end)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    -- spell-checker: disable-next-line
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    opts = { provider = "copilot" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  }
})
