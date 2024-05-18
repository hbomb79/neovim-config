-- Rust support doesn't need a plugin, we just want to
-- ensure the LSP configuration has run whenever we visit a .sql
-- file.
vim.api.nvim_create_autocmd("BufNew", {
	pattern = { "*.rs" },
	once = true,
	callback = function()
		require("plugins.config.lsp.rust")
		return true
	end,
})
