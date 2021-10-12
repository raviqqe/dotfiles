local cmp = require('cmp')

cmp.setup {
    formatting = {
        format = function(entry, item)
            item.menu = entry.source.name
            return item
        end
    },
    mapping = {
        ['<s-tab>'] = cmp.mapping.select_prev_item(),
        ['<tab>'] = cmp.mapping.select_next_item(),
        ['<cr>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    sources = {
        {name = "cmp_tabnine"}, {name = 'buffer'}, {name = 'nvim_lsp'},
        {name = 'path'}, {name = 'treesitter'}
    }
}

vim.api.nvim_exec(
    [[autocmd Rc FileType qf nnoremap <buffer> <cr> <cr>:cclose<cr>]], true)
