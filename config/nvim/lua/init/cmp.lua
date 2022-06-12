local cmp = require("cmp")

cmp.setup({
	formatting = {
		format = function(entry, item)
			item.menu = entry.source.name
			return item
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "buffer" },
		{ name = "copilot" },
		{ name = "emoji" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "treesitter" },
	},
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "Init",
	pattern = { "qf" },
	callback = function()
		vim.keymap.set("n", "<cr>", "<cr>:lclose<cr>", { buffer = true, noremap = true })
	end,
})
