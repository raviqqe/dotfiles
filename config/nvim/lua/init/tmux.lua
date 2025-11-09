local tmux = require("nvim-tmux-navigation")

vim.keymap.set("n", "<c-h>", tmux.NvimTmuxNavigateLeft)
vim.keymap.set("n", "<c-j>", tmux.NvimTmuxNavigateDown)
vim.keymap.set("n", "<c-k>", tmux.NvimTmuxNavigateUp)
vim.keymap.set("n", "<c-l>", tmux.NvimTmuxNavigateRight)
