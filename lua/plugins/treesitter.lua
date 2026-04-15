return {
	{
		"nvim-treesitter/nvim-treesitter",
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
	-- {
	-- 	"windwp/nvim-ts-autotag",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	ft = { "html", "svelte", "astro" },
	-- },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						include_surrounding_whitespace = true,
					},
					swap = {
						enable = true,
					},
					move = {
						enable = true,
						set_jumps = true,
					},
				},
			})

			-- Make treesitter-related movements repeatable using the standard ; and ,
			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- The above overwrites the builtin repeat bindings, so add them back.
			-- This is useful because unlike the builtin option, we can use this mechanism to repeat any
			-- action we like (such as moving between Git hunks or LSP diagnostics).
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			-- [[ Select bindings ]] --
			local ts_select = require("nvim-treesitter-textobjects.select")
			vim.keymap.set({ "x", "o" }, "af", function()
				ts_select.select_textobject("@function.outer", "textobjects")
			end, { desc = "Inside function" })
			vim.keymap.set({ "x", "o" }, "if", function()
				ts_select.select_textobject("@function.inner", "textobjects")
			end, { desc = "Around function" })
			vim.keymap.set({ "x", "o" }, "ac", function()
				ts_select.select_textobject("@class.outer", "textobjects")
			end, { desc = "Around class" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				ts_select.select_textobject("@class.inner", "textobjects")
			end, { desc = "Inside class" })

			-- [[ Swap bindings ]] --
			local ts_swap = require("nvim-treesitter-textobjects.swap")
			vim.keymap.set("n", "<leader>a", function()
				ts_swap.swap_next("@parameter.inner")
			end, { desc = "Swap param next" })
			vim.keymap.set("n", "<leader>A", function()
				ts_swap.swap_previous("@parameter.inner")
			end, { desc = "Swap param prev" })

			-- [[ Move bindings ]] --
			-- You can use the capture groups defined in `textobjects.scm`
			local ts_move = require("nvim-treesitter-textobjects.move")
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				ts_move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next fn start" })
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				ts_move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })

			-- You can also pass a list to group multiple queries.
			vim.keymap.set({ "n", "x", "o" }, "]o", function()
				ts_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
			end, { desc = "Next loop start" })

			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				ts_move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				ts_move.goto_next_end("@class.outer", "textobjects")
			end, { desc = "Next class end" })

			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				ts_move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev fn start" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				ts_move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Prev class start" })

			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				ts_move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Prev fn end" })
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				ts_move.goto_previous_end("@class.outer", "textobjects")
			end, { desc = "Prev class end" })
		end,
	},
}
