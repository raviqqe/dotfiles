require 'init.util'

require'compe'.setup {
    enabled = true,
    autocomplete = true,
    min_length = 1,
    preselect = 'enable',
    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true
    }
}

local options = {expr = true, noremap = true, silent = true}

vim.api.nvim_set_keymap('i', '<tab>', "v:lua.pumvisible('<c-n>', '<tab>')",
                        options)
vim.api.nvim_set_keymap('i', '<s-tab>', "v:lua.pumvisible('<c-p>', '<tab>')",
                        options)
vim.api.nvim_set_keymap('i', '<cr>', "compe#confirm('<cr>')", options)
