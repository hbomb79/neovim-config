require("lspconfig").lua_ls.setup({
	settings = { Lua = { workspace = { checkThirdParty = false } } },
})

require("lsp"):notify_new_lsp()
