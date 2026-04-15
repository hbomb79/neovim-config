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

--- Opens the Neogit plugin window using a specified working directory, which is
--- found by searching upwards for a .git directory
---
--- This was motivated by some weird behaviour when opening Neogit from
--- a sub-folder in a repo. It would correctly detect the changes,
--- but any attempt to view the diff, stage, unstage or discard would fail
--- because it couldn't find the file.
local function open_neogit()
	local git_paths = vim.fs.find(
		".git",
		{ upward = true, stop = vim.uv.os_homedir(), path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) }
	)

	local git_path
	if #git_paths > 0 then
		git_path = vim.fs.dirname(git_paths[1])
	end

	if git_path == nil then
		vim.notify("Failed to open Neogit: git repository not found", vim.log.levels.ERROR)
		return
	end

	vim.notify("Git repository found to be rooted at '" .. git_path .. "'", vim.log.levels.TRACE)
	require("neogit").open({ cwd = git_path })
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
			vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })

			-- Window keybinds
			vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<S-Left>", "<cmd>vertical resize -10<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<S-Right>", "<cmd>vertical resize +10<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<S-Up>", "<cmd>resize +10<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<S-Down>", "<cmd>resize -10<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<S-x>", "<cmd>bdelete<CR>", { noremap = true, silent = true })

			-- Hop.nvim keybinds
			whichkey.add({
				{ "<leader>h", group = "Hop" },
				{
					"<leader>hc",
					"<cmd>lua require('hop').hint_char1 {current_line_only = true}<CR>",
					desc = "Line Char",
				},
				{
					"<leader>hh",
					"<cmd>lua require('hop').hint_words {current_line_only = true}<CR>",
					desc = "Line Word",
				},
				{
					"<leader>hC",
					"<cmd>lua require('hop').hint_char1 {current_line_only = false}<CR>",
					desc = "Global Char",
				},
				{ "<leader>hH", "<cmd>lua require('hop').hint_words()<CR>", desc = "Global Word" },
				{ "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "LSP Hover" },
			})

			-- Continue the above pattern for plugin provided jumps
			local gs = require("gitsigns")
			local hunk_move = make_repeatable_move(function(forward)
				gs.nav_hunk(forward and "next" or "prev")
			end)

			local diag_move = make_repeatable_move(function(forward)
				vim.diagnostic.jump({ count = forward and 1 or -1 })
			end)

			local quickfix_move = make_repeatable_move(function(forward)
				protect_cmd(forward and "cnext" or "cprevious", "No quickfix items")
			end)

			local harpoon_move = make_repeatable_move(function(forward)
				if forward then
					require("harpoon.ui").nav_next()
				else
					require("harpoon.ui").nav_prev()
				end
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
				{ "<leader>;", "<cmd>Dashboard<CR>", desc = "Open Dashboard" },
				{ "<leader><leader>", "<cmd>nohlsearch<CR>", desc = "Clear Search Highlight" },
				-- { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "LSP Hover" },

				{ "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal file in Tree" },
				{ "<leader>e", "<cmd>Neotree last<CR>", desc = "Open File Tree" },

				-- [[ Search (with Telescope) ]] --
				{ "<leader>s", group = "Search" },
				{
					"<leader>sD",
					"<cmd>Telescope lsp_workspace_diagnostics<CR>",
					desc = "Workspace Diagnostics",
				},
				{ "<leader>sM", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
				{ "<leader>sR", "<cmd>Telescope registers<CR>", desc = "Registers" },
				{ "<leader>sc", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme" },
				{
					"<leader>sd",
					"<cmd>Telescope lsp_document_diagnostics<CR>",
					desc = "Document Diagnostics",
				},
				{ "<leader>sf", "<cmd>Telescope find_files<CR>", desc = "Find File" },
				{ "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find File" },
				{ "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help Tag" },
				{ "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Marks" },
				{
					"<leader>sr",
					"<cmd>Telescope oldfiles<CR>",
					desc = "Open Recent File",
				},
				{ "<leader>st", "<cmd>Telescope live_grep<CR>", desc = "Text" },

				-- [[ Quickfix ]] --
				{ "<leader>q", group = "Quickfix" },
				{ "<leader>qn", "<cmd>cnext<CR>", desc = "Next" },
				{ "<leader>qp", "<cmd>cprevious<CR>", desc = "Previous" },
				{ "<leader>qq", "<cmd>copen<CR>", desc = "Open" },
				{ "<leader>qx", "<cmd>cclose<CR>", desc = "Close" },

				-- [[ Git ]] --
				{ "<leader>G", open_neogit, desc = "Neogit" },

				{ "<leader>g", group = "Git" },
				{ "<leader>gP", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
				{ "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
				{ "<leader>gb", "<cmd>GitBlameToggle<CR>", desc = "Toggle Blame" },
				{
					"<leader>gc",
					"<cmd>Telescope git_branches<CR>",
					desc = "Checkout branch",
				},

				-- [[ Git -> Diff ]] --
				{ "<leader>gd", desc = "+Diff" },
				{
					"<leader>gdH",
					"<CMD>DiffviewFileHistory<CR>",
					desc = "Full commit history",
				},
				{
					"<leader>gdd",
					"<CMD>DiffviewOpen<CR>",
					desc = "Diff working tree",
				},
				{
					"<leader>gdh",
					"<CMD>DiffviewFileHistory %<CR>",
					desc = "File commit history",
				},
				{
					"<leader>gdo",
					"<CMD>DiffviewOpen origin/HEAD<CR>",
					desc = "Diff with origin",
				},
				{ "<leader>gdx", "<CMD>DiffviewClose<CR>", desc = "Close" },

				-- [[ Git -> Hunk Ops ]] --
				{
					"<leader>gp",
					"<cmd>Gitsigns preview_hunk_inline<CR>",
					desc = "Preview Hunk Inline",
				},
				{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
				{ "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
				{
					"<leader>gu",
					"<cmd>Gitsigns undo_stage_hunk<CR>",
					desc = "Undo Stage Hunk",
				},

				-- [[ Harpoon ]] --
				{ "<leader>p", group = "Harpoon" },
				{ "<leader>p1", "<cmd> lua require('harpoon.ui').nav_file(1)<CR>", desc = "File 1" },
				{ "<leader>p2", "<cmd> lua require('harpoon.ui').nav_file(2)<CR>", desc = "File 2" },
				{ "<leader>p3", "<cmd> lua require('harpoon.ui').nav_file(3)<CR>", desc = "File 3" },
				{ "<leader>pa", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Add file" },
				{ "<leader>pm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Menu" },
				{ "<leader>pn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", desc = "Next" },
				{ "<leader>pp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", desc = "Previous" },
				{ "<leader>pr", "<cmd>lua require('harpoon.mark').rm_file()<CR>", desc = "Remove file" },

				-- [[ Neotest ]] --
				{ "<leader>t", group = "Testing" },
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
