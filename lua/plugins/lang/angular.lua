return {
	{
		"joeveiga/ng.nvim",
		config = function()
			-- When providing a list to ensure_installed_sync I got weird
			-- errors... this isn't ideal but will do for now.. I guess
			require("nvim-treesitter.install").ensure_installed_sync("angular")
			require("nvim-treesitter.install").ensure_installed_sync("typescript")
			require("nvim-treesitter.install").ensure_installed_sync("css")
			require("nvim-treesitter.install").ensure_installed_sync("scss")
			require("nvim-treesitter.install").ensure_installed_sync("javascript")
			require("plugins.config.lsp.angular")
		end,
		ft = { "typescript", "html" },
	},
}
