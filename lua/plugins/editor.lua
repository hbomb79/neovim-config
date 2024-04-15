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
		"folke/trouble.nvim",
		branch = "dev",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			follow = false,
			focus = true,
			auto_refresh = false,
			auto_close = true,
		},
		config = function(_, opts)
			require("trouble").setup(opts)

			-- WARN this is fragile code which is designed to de-duplicate
			-- multiple items which reference the same location.
			-- If trouble breaks after an update, consider this your first suspect.
			require("plugins.config.trouble")
		end,
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
}
