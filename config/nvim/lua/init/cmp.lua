local cmp = require("cmp")

cmp.setup({
	formatting = {
		format = function(entry, item)
			item.menu = entry.source.name
			return item
		end,
	},
	mapping = {
		["<tab>"] = cmp.mapping.select_next_item(),
		["<s-tab>"] = cmp.mapping.select_prev_item(),
		["<cr>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
		}),
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = "buffer" },
		{ name = "copilot" },
		{ name = "emoji" },
		{ name = "nvim_lsp", priority = 100 },
		{ name = "path" },
		{ name = "treesitter" },
	}),
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("InitCmp", {}),
	pattern = { "qf" },
	callback = function()
		vim.keymap.set("n", "<cr>", "<cr>:lclose<cr>", { buffer = true, noremap = true })
	end,
})
