vim.lsp.inline_completion.enable(true)

local options = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, options)
vim.keymap.set("n", "<leader>e", vim.lsp.buf.references, options)
vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, options)
vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, options)
vim.keymap.set("n", "<leader>y", vim.lsp.buf.implementation, options)
vim.keymap.set("n", "<leader>x", vim.diagnostic.goto_next, options)
vim.keymap.set("n", "<leader>z", vim.diagnostic.setloclist, options)
vim.keymap.set('i', '<c-o>', '<cmd>lua vim.lsp.inline_completion.get()<cr>', options)

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})

vim.lsp.config("rumdl", {
  cmd = { 'rumdl', 'server' },
  filetypes = { 'markdown' },
  root_markers = { '.git' },
})

vim.lsp.enable({
  "astro",
  "biome",
  "cairo_ls",
  "clangd",
  "copilot",
  "docker_language_server",
  "efm",
  "eslint",
  "gopls",
  "lua_ls",
  "mdx_analyzer",
  "move_analyzer",
  "pylsp",
  "pyrefly",
  "rubocop",
  "ruff",
  "rumdl",
  "rust_analyzer",
  -- spell-checker: disable-next-line
  "solidity_ls_nomicfoundation",
  "sqruff",
  -- spell-checker: disable-next-line
  "terraformls",
  "tombi",
  "tsgo",
})

local group = vim.api.nvim_create_augroup("InitLsp", {})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*" },
  callback = function()
    vim.lsp.buf.format({
      filter = function(client)
        return client.name ~= "tsgo"
      end
    })
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
