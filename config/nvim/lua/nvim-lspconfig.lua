local lsp = require('lspconfig')

local function keymap(key, command)
    vim.api.nvim_set_keymap('n', key, command, {noremap = true, silent = true})
end

keymap('<leader>d', '<cmd>lua vim.lsp.buf.definition()<cr>')
keymap('<leader>e', '<cmd>lua vim.lsp.buf.references()<cr>')
keymap('<leader>n', '<cmd>lua vim.lsp.buf.rename()<cr>')
keymap('<leader>t', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
keymap('<leader>y', '<cmd>lua vim.lsp.buf.implementation()<cr>')

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {'documentation', 'detail', 'additionalTextEdits'}
}

for _, command in ipairs({"gopls", "rust_analyzer", "tsserver"}) do
    lsp[command].setup {capabilities = capabilities}
end
