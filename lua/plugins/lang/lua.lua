return {
	{
		"saadparwaiz1/cmp_luasnip",
		dependencies = { "L3MON4D3/LuaSnip" },
		ft = { "lua" },
	},
	{
		"folke/neodev.nvim",
		opts = {},
		config = function()
			require("neodev").setup({})
			require("nvim-treesitter.install").ensure_installed_sync("lua")
			require("nvim-treesitter.install").ensure_installed_sync("luadoc")
			require("plugins.config.lsp.lua")
		end,
		ft = { "lua" },
	},
}
