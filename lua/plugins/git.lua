--- Opens the Neogit plugin window using a specified working directory, which is
--- found by searching upwards for a .git directory
---
--- This was motivated by some weird behaviour when opening Neogit from
--- a sub-folder in a repo. It would correctly detect the changes,
--- but any attempt to view the diff, stage, unstage or discard would fail
--- because it couldn't find the file.
local function open_neogit()
	local git_paths = vim.fs.find(
		".git",
		{ upward = true, stop = vim.uv.os_homedir(), path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) }
	)

	local git_path
	if #git_paths > 0 then
		git_path = vim.fs.dirname(git_paths[1])
	end

	if git_path == nil then
		vim.notify("Failed to open Neogit: git repository not found", vim.log.levels.ERROR)
		return
	end

	vim.notify("Git repository found to be rooted at '" .. git_path .. "'", vim.log.levels.TRACE)
	require("neogit").open({ cwd = git_path })
end
return {
	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{ "<leader>g", desc = "Git" },
			{ "<leader>gP", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
			{ "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },

			-- [[ Git -> Hunk Ops ]] --
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview Hunk Inline" },
			{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
			{ "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
			{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },
		},
	},
	{
		"f-person/git-blame.nvim",
		cmd = "GitBlameToggle",
		keys = { { "<leader>gb", "<cmd>GitBlameToggle<CR>", desc = "Toggle Blame" } },
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
				kind = "split_below_all",
				console_timeout = 5000,
				integrations = {
					telescope = true,
					diffview = true,
				},
			})
		end,
		cmd = "Neogit",
		keys = {
			{ "<leader>G", open_neogit, desc = "Neogit" },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
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
		keys = {
			{ "<leader>gd", desc = "Diff" },
			{
				"<leader>gdH",
				"<CMD>DiffviewFileHistory<CR>",
				desc = "Full commit history",
			},
			{
				"<leader>gdd",
				"<CMD>DiffviewOpen<CR>",
				desc = "Diff working tree",
			},
			{
				"<leader>gdh",
				"<CMD>DiffviewFileHistory %<CR>",
				desc = "File commit history",
			},
			{
				"<leader>gdo",
				"<CMD>DiffviewOpen origin/HEAD<CR>",
				desc = "Diff with origin",
			},
			{ "<leader>gdx", "<CMD>DiffviewClose<CR>", desc = "Close" },
		},
	},
}
