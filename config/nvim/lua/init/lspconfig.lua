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

for _, command in ipairs({ "clangd", "gopls", "solargraph", "rust_analyzer" }) do
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
		"astro",
		"c",
		"css",
		"cucumber",
		"html",
		"html.handlebars",
		"javascript",
		"json",
		"jsonc",
		"lua",
		"markdown",
		"pen",
		"python",
		"ruby",
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

local group = vim.api.nvim_create_augroup("InitLsp", {})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = { "*" },
	callback = vim.lsp.buf.formatting_seq_sync,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = group,
	pattern = { "*" },
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})