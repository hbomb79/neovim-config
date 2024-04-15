-- nvim-lint is used to integrate other
-- non-LSP linters in to the editor.
require("lint").linters_by_ft = { go = { "golangcilint" } }
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
