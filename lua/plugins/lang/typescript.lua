return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({
				root_markets = { "package.json" },
				root_dir = nil,
				-- root_dir = function(bufnr, onDir)
				-- 	local util = require("lspconfig.util")
				-- 	return onDir(util.root_pattern("package.json"))
				-- end,
			})
		end,
	},
}
