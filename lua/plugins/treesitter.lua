return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn", -- set to `false` to disable one of the mappings
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				ensure_installed = {
					"go",
					"scala",
					"ocaml",
					"angular",
					"typescript",
					"javascript",
					"css",
					"scss",
					"markdown",
					"html",
					"lua",
					"luadoc",
					"gitcommit",
				},
				auto_install = true,
				highlight = { enable = true },
			})
		end,
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					max_lines = 5,
					multiline_threshold = 1,
					trim_scope = "inner",
				},
				lazy = false,
			},
		},
		build = ":TSUpdate",
		lazy = false,
	},
	{
		"andymass/vim-matchup",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = "%",
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "html", "svelte", "astro" },
	},
	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "TSPlaygroundToggle",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = { query = "@function.outer", desc = "Around Function" },
							["if"] = { query = "@function.inner", desc = "Inside Function" },
							["ac"] = { query = "@class.outer", desc = "Around Class" },
							["ic"] = { query = "@class.inner", desc = "Inside Class" },
							["as"] = { query = "@scope", query_group = "locals", desc = "Around Scope" },
						},
						include_surrounding_whitespace = true,
					},
					swap = {
						enable = true,
						swap_next = { ["<leader>a"] = "@parameter.inner" },
						swap_previous = { ["<leader>A"] = "@parameter.inner" },
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]n"] = { query = "@function.outer", desc = "Next fn start" },
							["]]"] = { query = "@class.outer", desc = "Next class" },
							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]M"] = { query = "@function.outer", desc = "Next fn end" },
							["]["] = { query = "@class.outer", desc = "Next class end" },
						},
						goto_previous_start = {
							["[n"] = { query = "@function.outer", desc = "Prev fn start" },
							["[["] = { query = "@class.outer", desc = "Prev class start" },
						},
						goto_previous_end = {
							["[M"] = { query = "@function.outer", desc = "Prev fn end" },
							["[]"] = { query = "@class.outer", desc = "Prev class end" },
						},
					},
				},
			})

			-- Make treesitter-related movements repeatable using the standard ; and ,
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
}
