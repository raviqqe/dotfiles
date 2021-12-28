local options = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', '<leader>d',
                        '<cmd>lua vim.lsp.buf.definition()<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>e',
                        '<cmd>lua vim.lsp.buf.references()<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>lua vim.lsp.buf.rename()<cr>',
                        options)
vim.api.nvim_set_keymap('n', '<leader>t',
                        '<cmd>lua vim.lsp.buf.type_definition()<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>y',
                        '<cmd>lua vim.lsp.buf.implementation()<cr>', options)
vim.api.nvim_set_keymap('n', '<leader>x',
                        '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', options)

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

for _, command in ipairs({"gopls", "rust_analyzer"}) do
    lspconfig[command].setup({capabilities = capabilities})
end

lspconfig.tsserver.setup({
    capabilities = capabilities,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
    end
})

lspconfig.efm.setup({
    capabilities = capabilities,
    filetypes = {
        "html", "javascript", "json", "lua", "markdown", "python", "sh", "toml",
        "typescript", "yaml", "zsh"
    }
})

vim.api.nvim_exec([[autocmd Init BufWritePre * lua vim.lsp.buf.formatting()]],
                  true)
