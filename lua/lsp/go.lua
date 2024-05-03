require("lspconfig").gopls.setup({
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			-- TODO: find a way to set this dynamically based on the project I am in.
			-- gofumpt = true,
		},
	},
})
require("lsp"):notify_new_lsp()
