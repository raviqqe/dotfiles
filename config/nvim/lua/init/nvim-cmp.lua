local cmp = require('cmp')

cmp.setup {
    formatting = {
        format = function(entry, item)
            item.menu = entry.source.name
            return item
        end
    },
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    sources = {
        {name = 'nvim_lsp'}, {name = 'buffer'}, {name = 'emoji'},
        {name = 'path'}, {name = 'treesitter'}
    }
}

vim.api.nvim_exec(
    [[autocmd Init FileType qf nnoremap <buffer> <cr> <cr>:cclose<cr>]], true)
