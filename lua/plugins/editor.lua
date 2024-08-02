return {
	{
		"tpope/vim-sensible",
	},
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
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = require("plugins.config.lualine"),
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("plugins.config.which-key")
		end,
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
		priority = 1000,
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
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undo tree" },
		},
	},
	{
		"tris203/precognition.nvim",
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
		"kylechui/nvim-surround",
		version = "*",
		keys = { "ys", "ds", "cs" },
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = true,
	},
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvimtools/hydra.nvim",
		},
		opts = {},
		cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
		keys = {
			{
				mode = { "v", "n" },
				"<Leader>m",
				"<cmd>MCstart<cr>",
				desc = "Create a selection for selected text or word under the cursor",
			},
		},
	},
}
