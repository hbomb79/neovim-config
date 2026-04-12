return {
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"f-person/git-blame.nvim",
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		dependencies = {
			"folke/which-key.nvim",
		},
		config = function()
			vim.opt.fillchars:append({ diff = "┈" })

			local actions = require("diffview.actions")
			require("diffview").setup({
				enhanced_diff_hl = true,
				keymaps = {
					file_history_panel = {
						{
							"n",
							"o",
							actions.open_in_diffview,
							{ desc = "Open the entry under the cursor in a diffview" },
						},
					},
				},
			})

			vim.api.nvim_set_keymap("v", "<leader>gd", ":DiffviewFileHistory<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"NeogitOrg/neogit",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("neogit").setup({
				disable_signs = true,
				graph_style = "unicode",
				kind = "split",
				console_timeout = 5000,
				integrations = {
					telescope = true,
					diffview = true,
				},
			})
		end,
		cmd = "Neogit",
	},
}
