---Accepts a function which will be called whenever a move is made or repeated. The function
---will be called with a boolean argument, indicating the direction (true = forward).
---
---This function will then return two wrapper functions which can be passed directly to vim.keymap.set
---or whichkey. These wrapped will automatically pass the forward boolean to the wrapper.
---
---@param move_fn fun(forward: boolean) the move function which will be used
---@return { next: fun(), prev: fun() } funcs the pair of directional move functions to map
local function make_repeatable_move(move_fn)
	local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
	local repeatable_move = ts_repeat_move.make_repeatable_move(function(opts)
		move_fn(opts.forward)
	end)

	return {
		next = function()
			repeatable_move({ forward = true })
		end,
		prev = function()
			repeatable_move({ forward = false })
		end,
	}
end

local function protect_cmd(cmd, err)
	local ok = pcall(vim.cmd[cmd])
	if not ok then
		vim.cmd("echohl @error | echo 'ERR: " .. err .. "'")
	end
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
		config = function()
			require("treesitter-context").setup({
				max_lines = 5,
				multiline_threshold = 1,
				trim_scope = "outer",
			})

			local colors = require("catppuccin.palettes").get_palette()
			vim.cmd("hi! TreesitterContext guibg=" .. colors.surface0)
			vim.cmd("hi! TreesitterContextBottom gui=None")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = true,
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

			-- [[ Repeatable moves ]] --

			-- Make treesitter-related movements repeatable using the standard ; and ,
			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- The above overwrites the builtin repeat bindings, so add them back.
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			-- Now add repeatable mappings for more than what is just built in, first, diagnostics:
			local diag_move = make_repeatable_move(function(forward)
				vim.diagnostic.jump({ count = forward and 1 or -1 })
			end)
			vim.keymap.set("n", "]d", diag_move.next, { desc = "Next diagnostic" })
			vim.keymap.set("n", "[d", diag_move.prev, { desc = "Prev diagnostic" })

			-- Next, the quickfix list
			local quickfix_move = make_repeatable_move(function(forward)
				protect_cmd(forward and "cnext" or "cprevious", "No quickfix items")
			end)
			vim.keymap.set("n", "];", quickfix_move.next, { desc = "Next quickfix" })
			vim.keymap.set("n", "[;", quickfix_move.prev, { desc = "Prev quickfix" })

			-- Define repeatable keymaps for gitsigns (if present)
			if require("zpack").get_plugin("gitsigns.nvim") ~= nil then
				local move = make_repeatable_move(function(forward)
					require("gitsigns").nav_hunk(forward and "next" or "prev")
				end)

				vim.keymap.set("n", "]h", move.next, { desc = "Next hunk" })
				vim.keymap.set("n", "[h", move.prev, { desc = "Prev hunk" })
			end

			-- Define repeatable moves for Harpoon (if present)
			if require("zpack").get_plugin("harpoon") ~= nil then
				local move = make_repeatable_move(function(forward)
					require("harpoon.ui")[forward and "nav_next" or "nav_prev"]()
				end)

				vim.keymap.set("n", "]p", move.next, { desc = "Next Harpoon" })
				vim.keymap.set("n", "]p", move.next, { desc = "Prev Harpoon" })
			end

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
