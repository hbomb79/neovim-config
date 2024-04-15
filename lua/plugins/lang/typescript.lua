return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript" },
		config = function()
			require("lsp.typescript")
			require("typescript-tools").setup({
				root_dir = require("lspconfig.util").root_pattern("package.json"),
			})
		end,
	},
}
