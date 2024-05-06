return {
	{
		"tjdevries/ocaml.nvim",
		config = function()
			require("ocaml").update()
			require("ocaml").setup()
			require("plugins.config.lsp.ocaml")
		end,
		ft = { "ocaml" },
	},
}
