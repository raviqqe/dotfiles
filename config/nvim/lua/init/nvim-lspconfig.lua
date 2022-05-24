local options = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, options)
vim.keymap.set("n", "<leader>e", vim.lsp.buf.references, options)
vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, options)
vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, options)
vim.keymap.set("n", "<leader>y", vim.lsp.buf.implementation, options)
vim.keymap.set("n", "<leader>x", vim.diagnostic.goto_next, options)
vim.keymap.set("n", "<leader>z", vim.diagnostic.setloclist, options)

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local lspconfig = require("lspconfig")

for _, command in ipairs({ "gopls", "rust_analyzer" }) do
	lspconfig[command].setup({ capabilities = capabilities })
end

lspconfig.tsserver.setup({
	capabilities = capabilities,
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
	end,
})

lspconfig.efm.setup({
	capabilities = capabilities,
	filetypes = {
		"c",
		"cucumber",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"pen",
		"python",
		"sh",
		"sql",
		"terraform",
		"text",
		"toml",
		"typescript",
		"typescriptreact",
		"xml",
		"yaml",
		"zsh",
	},
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = "Init",
	pattern = { "*" },
	callback = vim.lsp.buf.formatting_seq_sync,
})
