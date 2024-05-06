return {
	{
		"scalameta/nvim-metals",
		ft = { "scala", "sbt" },
		config = function()
			require("plugins.config.lsp.scala")
		end,
	},
}
