return {
	-- Automatically enables LSPs (e.g. vim.lsp.enable) which have been installed via Mason. Eagerly loaded.
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			-- Used to manage installs of various binaries for formatting, linting, LSPs, etc.
			{ "williamboman/mason.nvim", opts = {} },

			-- Updates the built-in LSP configs with those from GitHub. This isn't
			-- strictly required anymore (since v0.11), but is a nice to have.
			{ "neovim/nvim-lspconfig" },
		},
		priority = 1000,
	},

	-- LSP progress updates in the bottom-right corner of the editor.
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			progress = {
				suppress_on_insert = true,
				display = {
					render_limit = 5,
					progress_icon = { "arc" },
				},
			},
			notification = {
				window = { winblend = 0 },
			},
		},
	},

	-- Provides popup information about a method/function signature as you
	-- type the arguments in. Very handy!
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = { hint_enable = false },
	},

	-- Automatic linting of files on buffer write. Linters to use are provided
	-- by the language specs (in the 'langs' dir).
	{
		"mfussenegger/nvim-lint",
		event = { "BufWinEnter", "BufWritePost" },
		config = function()
			require("lint").linters_by_ft = require("langs"):get_linters_by_ft()

			-- Auto lint on save
			vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
				callback = function()
					local ok, err = pcall(require("lint").try_lint)
					if not ok and err ~= nil then
						vim.notify("Lint error: " .. vim.inspect(err), vim.log.levels.ERROR)
					end
				end,
			})
		end,
	},

	-- Automatic formatting of files on buffer write. Formatters to use are provided
	-- by the language specs (in the 'langs' dir)
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = require("langs"):get_formatters_by_ft(),
			format_on_save = { timeout_ms = 2500, lsp_fallback = true },
		},
	},

	-- Testing framework to run/view tests inside of editor.
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			unpack(require("langs"):get_neotest_dependencies()),

			-- Should no longer need this plugin, leaving here for now as a breadcrumb
			-- in case it breaks
			-- "antoinemadec/FixCursorHold.nvim",
		},
		keys = {
			{ "<leader>t", desc = "Neotest" },
			{
				"<leader>tF",
				"<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>",
				desc = "Toggle file watch",
			},
			{
				"<leader>ta",
				"<cmd>lua require('neotest').run.attach(require('neotest').run.get_last_run())<CR>",
				desc = "Attach to tests",
			},
			{
				"<leader>tf",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
				desc = "Run file tests",
			},
			{ "<leader>to", "<cmd>lua require('neotest').output.open()<CR>", desc = "Test output" },
			{ "<leader>ts", "<cmd>lua require('neotest').run.run()<CR>", desc = "Run single test" },
			{ "<leader>tt", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Toggle summary" },
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("neotest").setup({
				adapters = require("langs"):get_neotest_adapters(),
			})
		end,
	},
}
