return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
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

			local colors = require("catppuccin.palettes").get_palette()
			-- Set colors for floating windows (e.g. LSP hover)
			vim.cmd("hi! NormalFloat guibg=" .. colors.mantle)
			vim.cmd("hi! FloatBorder guibg=" .. colors.mantle)

			-- Make telescope floating window transparent, as an exception to the above
			vim.cmd("hi! TelescopeNormal guibg=None")
			vim.cmd("hi! TelescopeBorder guifg=#89b4fa guibg=None")
			vim.cmd("hi! TelescopeTitle guifg=None")
		end,
	},
}
