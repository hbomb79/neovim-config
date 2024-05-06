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
			require("diffview").setup({ enhanced_diff_hl = true })

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
			-- The nightly branch is broken for me at the moment (weird folding behaviour), but this notification
			-- to use it is very annoying. Patch the 'info' function to ignore this message.
			local info = require("neogit.lib.notification").info
			---@diagnostic disable-next-line: duplicate-set-field
			require("neogit.lib.notification").info = function(...)
				if select(1, ...) ~= "The 'nightly' branch for Neogit provides support for nvim-0.10" then
					info(...)
				end
			end

			require("neogit").setup({
				disable_signs = true,
				graph_style = "unicode",
				kind = "split",
				console_timeout = 500,
				integrations = {
					telescope = true,
					diffview = true,
				},
			})
		end,
		cmd = "Neogit",
	},
}
