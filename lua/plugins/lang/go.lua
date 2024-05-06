return {
	{
		"ray-x/go.nvim",
		dependencies = { "ray-x/guihua.lua" },
		config = function()
			require("go").setup({})
			require("plugins.config.lsp.go")
		end,
		ft = { "go", "gomod" },
	},
}
