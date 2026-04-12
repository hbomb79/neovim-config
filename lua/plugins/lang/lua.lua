return {
	{
		"saadparwaiz1/cmp_luasnip",
		dependencies = { "L3MON4D3/LuaSnip" },
	},
	{
		"folke/lazydev.nvim",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "LazyVim", words = { "LazyVim" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
				{ path = "nvim-lspconfig", words = { "lspconfig.settings" } },
			},
		},
	},
}
