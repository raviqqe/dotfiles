local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.completion.spell,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.clang_format,
		null_ls.builtins.formatting.elm_format,
		null_ls.builtins.formatting.eslint,
		null_ls.builtins.formatting.pg_format,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.rubocop,
		null_ls.builtins.formatting.shfmt.with({
			extra_args = { "-i", "2" },
			extra_filetypes = { "zsh" },
		}),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.taplo,
		null_ls.builtins.formatting.terraform_fmt,
	},
})
