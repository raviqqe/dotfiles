local metals = require("metals")
local config = metals.bare_config()

config.settings = { showImplicitArguments = true }
config.init_options.statusBarProvider = "on"
config.capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	callback = function()
		metals.initialize_or_attach(config)
	end,
	group = vim.api.nvim_create_augroup("metals", { clear = true }),
})
