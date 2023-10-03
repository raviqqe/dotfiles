local options = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, options)
vim.keymap.set("n", "<leader>e", vim.lsp.buf.references, options)
vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, options)
vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, options)
vim.keymap.set("n", "<leader>y", vim.lsp.buf.implementation, options)
vim.keymap.set("n", "<leader>x", vim.diagnostic.goto_next, options)
vim.keymap.set("n", "<leader>z", vim.diagnostic.setloclist, options)

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, command in ipairs({ "astro", "clangd", "gopls", "solargraph", "rust_analyzer" }) do
	lspconfig[command].setup({ capabilities = capabilities })
end

lspconfig.tsserver.setup({
	capabilities = capabilities,
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

lspconfig.efm.setup({
	capabilities = capabilities,
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = true
	end,
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
		"scheme",
		"sh",
		"sql",
		"terraform",
		"text",
		"toml",
		"typescript",
		"typescriptreact",
		"wat",
		"xml",
		"yaml",
		"zsh",
	},
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
