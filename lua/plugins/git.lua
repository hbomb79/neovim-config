return {
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"f-person/git-blame.nvim",
	},
	{
		"tpope/vim-fugitive",
		cmd = "G",
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
}
