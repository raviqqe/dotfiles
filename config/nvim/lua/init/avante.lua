vim.keymap.set(
  "n",
  "<leader>a",
  function()
    vim.cmd("AvanteToggle")
  end,
  { noremap = true, silent = true }
)
