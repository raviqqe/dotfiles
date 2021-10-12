require('init.util')

local cmp = require('cmp')

cmp.setup {
    mapping = {
        ['<c-p>'] = cmp.mapping.select_prev_item(),
        ['<c-n>'] = cmp.mapping.select_next_item(),
        ['<cr>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    sources = {{name = 'buffer'}, {name = 'nvim_lsp'}, {name = 'path'}}
}

local options = {expr = true, noremap = true, silent = true}

vim.api.nvim_set_keymap('i', '<tab>', "v:lua.pumvisible('<c-n>', '<tab>')",
                        options)
vim.api.nvim_set_keymap('i', '<s-tab>', "v:lua.pumvisible('<c-p>', '<tab>')",
                        options)

vim.api.nvim_exec([[
    autocmd Rc FileType qf nnoremap <buffer> <cr> <cr>:cclose<cr>
]], true)
