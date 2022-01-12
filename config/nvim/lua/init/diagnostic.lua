local options = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', '<leader>x',
                        '<cmd>lua vim.diagnostic.goto_next()<cr>', options)

vim.api.nvim_exec([[
  augroup InitDiagnostic
    autocmd!

    autocmd DiagnosticChanged * lua require('init.diagnostic').update_loclist()
  augroup end
]], true)

return {
    update_loclist = function()
        if #vim.diagnostic.get() == 0 then
            vim.api.nvim_command('lclose')
        else
            vim.diagnostic.setloclist({open = true})
        end
    end
}
