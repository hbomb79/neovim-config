return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>s", nil, desc = "Search" },
			{
				"<leader>sD",
				"<cmd>Telescope lsp_workspace_diagnostics<CR>",
				desc = "Workspace Diagnostics",
			},
			{ "<leader>sM", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
			{ "<leader>sR", "<cmd>Telescope registers<CR>", desc = "Registers" },
			{ "<leader>sc", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme" },
			{
				"<leader>sd",
				"<cmd>Telescope lsp_document_diagnostics<CR>",
				desc = "Document Diagnostics",
			},
			{ "<leader>sf", "<cmd>Telescope find_files<CR>", desc = "Find File" },
			{ "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find File" },
			{ "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help Tag" },
			{ "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Marks" },
			{
				"<leader>sr",
				"<cmd>Telescope oldfiles<CR>",
				desc = "Open Recent File",
			},
			{ "<leader>st", "<cmd>Telescope live_grep<CR>", desc = "Text" },
			{ "<leader>gc", "<cmd>Telescope git_branches<CR>", desc = "Checkout branch" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
			"nvim-telescope/telescope-fzy-native.nvim",
			"nvim-telescope/telescope-project.nvim",
		},
	},
}
