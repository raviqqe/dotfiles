local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({defaults = {mappings = {i = {["<esc>"] = actions.close}}}})

local options = {noremap = true}

vim.api.nvim_set_keymap('n', '<leader>b',
                        [[<cmd>lua require('telescope.builtin').buffers()<cr>]],
                        options)
vim.api.nvim_set_keymap('n', '<leader>c',
                        [[<cmd>lua require('telescope.builtin').command_history()<cr>]],
                        options)
vim.api.nvim_set_keymap('n', '<leader>f',
                        [[<cmd>lua require('telescope.builtin').find_files()<cr>]],
                        options)
vim.api.nvim_set_keymap('n', '<leader>g',
                        [[<cmd>lua require('telescope.builtin').live_grep()<cr>]],
                        options)
vim.api.nvim_set_keymap('n', '<leader>r',
                        [[<cmd>lua require('telescope.builtin').git_files({use_git_root=true})<cr>]],
                        options)
