require("treesitter-context").setup()
require("nvim-treesitter-textobjects").setup()

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("Treesitter", {}),
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

vim.keymap.set({ "x", "o" }, "of", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "oc", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "os", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
end)
