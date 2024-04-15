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
			require("lsp.lua")
		end,
		ft = { "lua" },
	},
}
