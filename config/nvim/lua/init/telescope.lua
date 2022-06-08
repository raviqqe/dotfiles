local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		layout_strategy = "bottom_pane",
		layout_config = {
			bottom_pane = {
				height = 1000,
				prompt_position = "bottom",
			},
		},
		mappings = {
			i = { ["<esc>"] = actions.close },
		},
		path_display = { "truncate" },
	},
})

local options = { noremap = true }

vim.keymap.set("n", "<leader>b", builtin.buffers, options)
vim.keymap.set("n", "<leader>c", builtin.command_history, options)
vim.keymap.set("n", "<leader>f", builtin.find_files, options)
vim.keymap.set("n", "<leader>g", builtin.live_grep, options)
vim.keymap.set("n", "<leader>r", function()
	builtin.git_files({ use_git_root = true })
end, options)

return {
	find_files = function()
		if not pcall(builtin.git_files, { use_git_root = false }) then
			builtin.find_files()
		end
	end,
}
