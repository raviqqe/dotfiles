local options = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, options)
vim.keymap.set("n", "<leader>e", vim.lsp.buf.references, options)
vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, options)
vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, options)
vim.keymap.set("n", "<leader>y", vim.lsp.buf.implementation, options)
vim.keymap.set("n", "<leader>x", vim.diagnostic.goto_next, options)
vim.keymap.set("n", "<leader>z", vim.diagnostic.setloclist, options)

vim.lsp.enable({
  "astro",
  "biome",
  "cairo_ls",
  "clangd",
  "docker_language_server",
  "efm",
  "eslint",
  "gopls",
  "lua_ls",
  "mdx_analyzer",
  "move_analyzer",
  "pylsp",
  "pyrefly",
  "pyright",
  "rubocop",
  "ruff",
  "rust_analyzer",
  "solargraph",
  -- spell-checker: disable-next-line
  "solidity_ls_nomicfoundation",
  "sqruff",
  -- spell-checker: disable-next-line
  "terraformls",
  "tombi",
  "ts_ls",
}, {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

local group = vim.api.nvim_create_augroup("InitLsp", {})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
