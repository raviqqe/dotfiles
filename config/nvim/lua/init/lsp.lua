local options = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, options)
vim.keymap.set("n", "<leader>e", vim.lsp.buf.references, options)
vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, options)
vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, options)
vim.keymap.set("n", "<leader>y", vim.lsp.buf.implementation, options)
vim.keymap.set("n", "<leader>x", vim.diagnostic.goto_next, options)
vim.keymap.set("n", "<leader>z", vim.diagnostic.setloclist, options)

for _, command in ipairs({
	"astro",
	"efm",
	"clangd",
	"gopls",
	"mdx_analyzer",
	"pylsp",
	"pyright",
	"rust_analyzer",
	"solargraph",
	"ts_ls",
}) do
	vim.lsp.enable(command, {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})
end

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
