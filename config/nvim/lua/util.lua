local function special_key(key)
    return vim.api.nvim_replace_termcodes(key, true, true, true)
end

function _G.pumvisible(one, other)
    return vim.fn.pumvisible() == 1 and special_key(one) or special_key(other)
end
