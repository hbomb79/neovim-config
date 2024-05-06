return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"scala",
					"ocaml",
					"angular",
					"typescript",
					"javascript",
					"css",
					"scss",
					"markdown",
					"html",
					"lua",
					"luadoc",
					"gitcommit",
				},
				auto_install = true,
				highlight = { enable = true },
			})
		end,
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				config = true,
				lazy = false,
			},
		},
		build = ":TSUpdate",
		lazy = false,
	},
	{
		"andymass/vim-matchup",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = "%",
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "html", "svelte", "astro" },
	},
	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "TSPlaygroundToggle",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
