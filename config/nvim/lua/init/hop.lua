local flash = require("flash")

flash.setup()

vim.keymap.set("n", "<leader>s", function() flash.jump() end)
