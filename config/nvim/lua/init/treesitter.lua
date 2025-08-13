require("treesitter-context").setup()
require("nvim-treesitter-textobjects").setup()

require("nvim-treesitter").install({
  "bash",
  "cairo",
  "cpp",
  "css",
  "go",
  "graphql",
  "guile",
  "haskell",
  "html",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "julia",
  "kotlin",
  "lua",
  "markdown",
  "ocaml",
  "python",
  "ruby",
  "rust",
  "scala",
  "solidity",
  "sql",
  "swift",
  "toml",
  "typescript",
  "xml",
})
vim.treesitter.language.register("bash", { "sh", "zsh" })

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    -- spell-checker: disable-next-line
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- spell-checker: disable-next-line
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
