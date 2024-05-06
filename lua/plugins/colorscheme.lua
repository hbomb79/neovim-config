return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				term_colors = true,
				dim_inactive = {
					enabled = true,
					shade = "dark",
					percentage = 0.15,
				},
				default_integrations = true,
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
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
