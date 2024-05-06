return {
	{
		"neovim/nvim-lspconfig",
		{
			"williamboman/mason.nvim",
			config = true,
			dependencies = { "williamboman/mason-lspconfig.nvim" },
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = { automatic_installation = true },
			config = true,
		},
		-- Ensure both mason and mason-lspconfig are loaded BEFORE we do any language/LSP setup by disabling lazy.
		-- This is basically the case anyway due to the lazy loading of the lang plugins based on filetype
		lazy = false,
		priority = 1000,
	},
	{
		"hrsh7th/nvim-cmp",
		opts = function()
			return require("plugins.config.nvim-cmp")
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
		},
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = { text = { spinner = "arc" } },
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = { hint_enable = false },
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = { go = { "golangcilint" } }
			vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		dependencies = {
			{
				-- Auto install formatters if not present, must be loaded AFTER conform (which itself must be loaded AFTER mason.nvim).
				"zapling/mason-conform.nvim",
				lazy = false,
				config = true,
			},
		},
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
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"stevanmilic/neotest-scala",
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("neotest").setup({
				adapters = {
					require("neotest-scala")({
						-- Command line arguments for runner
						-- Can also be a function to return dynamic values
						args = { "--no-color" },
						-- Runner to use. Will use bloop by default.
						-- Can be a function to return dynamic value.
						-- For backwards compatibility, it also tries to read the vim-test scala config.
						-- Possibly values bloop|sbt.
						runner = "sbt",
						-- Test framework to use. Will use utest by default.
						-- Can be a function to return dynamic value.
						-- Possibly values utest|munit|scalatest.
						framework = "scalatest",
					}),
				},
			})
		end,
		lazy = true,
	},
}
