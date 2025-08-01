require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["ac"] = "@class.outer",
        ["as"] = "@scope",
      },
    },
  },
})
