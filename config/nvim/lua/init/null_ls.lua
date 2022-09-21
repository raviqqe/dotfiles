require("null-ls").setup({
	sources = {
		require("null-ls").builtins.completion.spell,
		require("null-ls").builtins.diagnostics.eslint,
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.clang_format,
		require("null-ls").builtins.formatting.elm_format,
		require("null-ls").builtins.formatting.eslint,
		require("null-ls").builtins.formatting.pg_format,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.formatting.rubocop,
		require("null-ls").builtins.formatting.shfmt.with({ extra_args = { "-i", "2" } }),
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.taplo,
		require("null-ls").builtins.formatting.terraform_fmt,
	},
})
