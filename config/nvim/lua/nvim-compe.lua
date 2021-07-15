require('util')

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
    nvim_lua = true,
  },
}

vim.api.nvim_set_keymap('i', '<tab>', "v:lua.pumvisible('<c-n>', '<tab>')", { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<s-tab>', "v:lua.pumvisible('<c-p>', '<tab>')", { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<cr>', "compe#confirm('<cr>')", { expr = true, noremap = true, silent = true })
