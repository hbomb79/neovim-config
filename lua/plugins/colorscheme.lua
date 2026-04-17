return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				float = {
					transparent = true,
					solid = false,
				},
				flavour = "mocha",
				term_colors = false,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
				-- default_integrations = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					notify = true,
					fidget = true,
					harpoon = true,
					hop = true,
					mason = true,
					gitgutter = true,
					telescope = true,
					which_key = true,
					mini = {
						enabled = true,
					},
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
