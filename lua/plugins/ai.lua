return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {},
		enabled = vim.fn.executable("claude") == 1,
		keys = {
			{ "<leader>c", nil, desc = "Claude Code" },
			{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{
				"<leader>cs",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },

			-- Visual mode keymaps
			{ "<leader>c", nil, mode = "v", desc = "Claude Code" },
			{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		},
	},
}
