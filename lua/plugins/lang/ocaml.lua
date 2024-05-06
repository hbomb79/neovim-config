return {
	{
		"tjdevries/ocaml.nvim",
		config = function()
			require("ocaml").update()
			require("ocaml").setup()
			require("nvim-treesitter.install").ensure_installed_sync("ocaml")
			require("plugins.config.lsp.ocaml")
		end,
		ft = { "ocaml" },
	},
}
