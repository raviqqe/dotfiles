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
  "alexghergh/nvim-tmux-navigation",
  "cappyzawa/trim.nvim",
  "catgoose/nvim-colorizer.lua",
  "folke/flash.nvim",
  "hoob3rt/lualine.nvim",
  "ibhagwan/fzf-lua",
  "kylechui/nvim-surround",
  "lewis6991/gitsigns.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "mateuszwieloch/automkdir.nvim",
  "maxbrunsfeld/vim-yankstack",
  "nxhung2304/lastplace.nvim",
  "tpope/vim-abolish",
  "tpope/vim-fugitive",
  "windwp/nvim-autopairs",
  { "nvim-treesitter/nvim-treesitter",             branch = "main" },
  "nvim-treesitter/nvim-treesitter-context",
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main", },

  -- Languages

  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-emoji",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-path",
  "hrsh7th/nvim-cmp",
  "neovim/nvim-lspconfig",
  "pen-lang/pen.vim",
  "ray-x/cmp-treesitter",
  "ray-x/lsp_signature.nvim",
})
