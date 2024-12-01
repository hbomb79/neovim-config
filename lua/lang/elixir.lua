-- Elixir support doesn't need a plugin, we just want to
-- ensure the LSP configuration has run whenever we visit a .ex
-- file.
vim.api.nvim_create_autocmd("BufNew", {
	pattern = { "*.ex" },
	once = true,
	callback = function()
		require("plugins.config.lsp.elixir")
		return true
	end,
})
