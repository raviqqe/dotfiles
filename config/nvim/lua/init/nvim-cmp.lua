require 'init.util'

local cmp = require 'cmp'

cmp.setup {
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    sources = {{name = 'buffer'}, {name = 'nvim_lsp'}}
}

local options = {expr = true, noremap = true, silent = true}

vim.api.nvim_set_keymap('i', '<tab>', "v:lua.pumvisible('<c-n>', '<tab>')",
                        options)
vim.api.nvim_set_keymap('i', '<s-tab>', "v:lua.pumvisible('<c-p>', '<tab>')",
                        options)
