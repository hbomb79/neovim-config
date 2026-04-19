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
		"folke/which-key.nvim",
		config = function()
			-- Base keybindings, which rely on WhichKey to configure.
			-- For LSP related keybindings, refer to the lsp.lua file, which dynamically
			-- creates keybindings on LSP attach.
			local whichkey = require("which-key")

			-- Default options are fine
			whichkey.setup({ preset = "helix" })

			-- Set leader
			vim.keymap.set("n", "<Space>", "<NOP>")

			-- Window keybinds
			vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>")
			vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>")
			vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>")
			vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>")
			vim.keymap.set({ "n", "t" }, "<S-Left>", "<cmd>vertical resize -10<CR>")
			vim.keymap.set({ "n", "t" }, "<S-Right>", "<cmd>vertical resize +10<CR>")
			vim.keymap.set({ "n", "t" }, "<S-Up>", "<cmd>resize +10<CR>")
			vim.keymap.set({ "n", "t" }, "<S-Down>", "<cmd>resize -10<CR>")
			vim.keymap.set("n", "<S-x>", "<cmd>bdelete<CR>")
			vim.keymap.set("t", "<S-x>", "<cmd>bdelete!<CR>")

			local hunk_move = make_repeatable_move(function(forward)
				require("gitsigns").nav_hunk(forward and "next" or "prev")
			end)

			local diag_move = make_repeatable_move(function(forward)
				vim.diagnostic.jump({ count = forward and 1 or -1 })
			end)

			local quickfix_move = make_repeatable_move(function(forward)
				protect_cmd(forward and "cnext" or "cprevious", "No quickfix items")
			end)

			local harpoon_move = make_repeatable_move(function(forward)
				require("harpoon.ui")[forward and "nav_next" or "nav_prev"]()
			end)

			whichkey.add({
				-- Repeatable 'next' commands
				{ "];", quickfix_move.next, desc = "Next Quickfix" },
				{ "]d", diag_move.next, desc = "Next Diagnostic" },
				{ "]h", hunk_move.next, desc = "Next Hunk" },
				{ "]p", harpoon_move.next, desc = "Next Harpoon" },

				-- Repeatable 'previous' commands
				{ "[;", quickfix_move.prev, desc = "Prev Quickfix" },
				{ "[d", diag_move.prev, desc = "Prev Diagnostic" },
				{ "[h", hunk_move.prev, desc = "Prev Hunk" },
				{ "[p", harpoon_move.prev, desc = "Prev Harpoon" },
			})

			-- Configure <leader> keymaps (default leader is space) in normal-mode
			-- Specific keymaps for LSPs/languages may be set elsewhere (typically
			-- in an LSPs onattach (see lsp/init.lua)
			whichkey.add({
				{ "<leader><leader>", "<cmd>nohlsearch<CR>", desc = "Clear Search Highlight" },

				{ "<leader>q", group = "Quickfix" },
				{ "<leader>qp", "<cmd>cprevious<CR>", desc = "Previous" },
				{ "<leader>qn", "<cmd>cnext<CR>", desc = "Next" },
				{ "<leader>qq", "<cmd>copen<CR>", desc = "Open" },
				{ "<leader>qx", "<cmd>cclose<CR>", desc = "Close" },
			})

			-- Configure visual-mode leader-based mappings
			whichkey.add({
				{
					mode = { "v" },
					{ "<leader>g", group = "Git" },
					{ "<leader>gd", ":DiffviewFileHistory<CR>", desc = "Range Git History" },
				},
			})
		end,
	},
}
