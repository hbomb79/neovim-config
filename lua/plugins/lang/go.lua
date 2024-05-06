return {
	{
		"ray-x/go.nvim",
		dependencies = { "ray-x/guihua.lua" },
		config = function()
			require("go").setup({})
			require("nvim-treesitter.install").ensure_installed_sync("go")
			require("plugins.config.lsp.go")
		end,
		ft = { "go", "gomod" },
	},
}
