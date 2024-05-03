return {
	"tpope/vim-sensible",
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"tpope/vim-commentary",
		cmd = "Commentary",
	},
	{
		"ThePrimeagen/harpoon",
		opts = { menu = { width = 120 } },
		lazy = true,
	},
	{
		"freddiehaddad/feline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin",
		},
		opts = function()
			return require("plugins.config.feline")
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("plugins.config.which-key")
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				typescript = { { "prettierd", "prettier" } },
				javascript = { { "prettierd", "prettier" } },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			close_if_last_window = true,
			source_selector = {
				winbar = true,
			},
		},
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
	},
	{
		"phaazon/hop.nvim",
		opts = { keys = "etovxqpdygfblzhckisuran" },
		branch = "v2",
		lazy = true,
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
			vim.notify_once = require("notify")
		end,
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	{
		"kevinhwang91/nvim-bqf",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "junegunn/fzf", build = "./install --bin" },
		},
		config = true,
	},
	{
		"tris203/precognition.nvim",
	},
}
