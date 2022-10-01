local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

null_ls.setup({
	sources = {
		null_ls.builtins.completion.spell,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.clang_format,
		null_ls.builtins.formatting.elm_format,
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
		helpers.make_builtin({
			name = "pen",
			method = null_ls.methods.FORMATTING,
			filetypes = { "pen" },
			generator_opts = {
				command = "pen",
				args = { "format", "--stdin" },
				to_stdin = true,
			},
			factory = helpers.formatter_factory,
		}),
	},
})
