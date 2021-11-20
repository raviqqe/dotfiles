local null_ls = require('null-ls')

null_ls.config({
    sources = {
        -- null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.rubocop, null_ls.builtins.diagnostics.vint,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.clang_format,
        -- null_ls.builtins.formatting.eslint,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.rubocop,
        null_ls.builtins.formatting.rustfmt.with({ignore_stderr = true}),
        null_ls.builtins.formatting.shfmt.with({args = {"-i", "2"}}),
        null_ls.builtins.formatting.taplo,
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.zigfmt
    }
})

require('lspconfig')["null-ls"].setup({})
