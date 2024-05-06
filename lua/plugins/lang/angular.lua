return {
	{
		"joeveiga/ng.nvim",
		config = function()
			require("plugins.config.lsp.angular")
		end,
		ft = { "typescript", "html" },
	},
}
