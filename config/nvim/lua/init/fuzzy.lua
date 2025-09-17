local fzf = require("fzf-lua")

vim.env.FZF_DEFAULT_OPTS = nil

fzf.setup({
  defaults = { file_icons = false },
  fzf_opts = { ['--layout'] = 'default' },
  git = { files = { cwd_header = false } },
  grep = { no_header_i = true },
  -- spell-checker: disable-next-line
  winopts = { fullscreen = true },
})

local options = { noremap = true }

vim.keymap.set("n", "<leader>b", fzf.buffers, options)
vim.keymap.set("n", "<leader>c", fzf.command_history, options)
vim.keymap.set("n", "<leader>f", fzf.files, options)
vim.keymap.set("n", "<leader>g", fzf.live_grep_native, options)
vim.keymap.set("n", "<leader>r", fzf.git_files, options)
