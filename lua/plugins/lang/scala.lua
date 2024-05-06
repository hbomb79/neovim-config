return {
	{
		"scalameta/nvim-metals",
		ft = { "scala", "sbt" },
		config = function()
			require("nvim-treesitter.install").ensure_installed_sync("scala")
			require("plugins.config.lsp.scala")
		end,
	},
}
