return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact" },
		config = function()
			require("plugins.config.lsp.typescript")
			require("typescript-tools").setup({
				root_dir = require("lspconfig.util").root_pattern("package.json"),
			})
		end,
	},
}
