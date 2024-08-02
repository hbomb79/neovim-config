-- Base keybindings, which rely on WhichKey to configure.
-- For keybindingd which are tightly coupled to a specific plugin, you'll
-- find those bindings in that specific plugins configuration.

local whichkey = require("which-key")

-- Default options are fine
whichkey.setup({})

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

-- Configure <leader>-less, normal-mode keymaps
-- Make jump mappings repeatable using ; and ,

local function protect_cmd(cmd, err)
	return function()
		---@diagnostic disable-next-line: param-type-mismatch
		local ok = pcall(vim.cmd, cmd)
		if not ok then
			vim.cmd("echohl @error | echo 'ERR: " .. err .. "'")
		end
	end
end

local gs = require("gitsigns")
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
local next_diag_repeat, prev_diag_repeat =
	ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
local next_qf_repeat, prev_qf_repeat = ts_repeat_move.make_repeatable_move_pair(
	protect_cmd("cnext", "No quickfix items"),
	protect_cmd("cprevious", "No quickfix items")
)

whichkey.add({
	{ "<S-x>", "<cmd>bdelete<CR>", desc = "Buffer Delete" },
	{ "H", group = "Hop" },
	{ "HC", "<cmd>lua require('hop').hint_char1 {current_line_only = true}<CR>", desc = "Line Char" },
	{ "HH", "<cmd>lua require('hop').hint_words {current_line_only = true}<CR>", desc = "Line Word" },
	{ "Hc", "<cmd>lua require('hop').hint_char1 {current_line_only = false}<CR>", desc = "Global Char" },
	{ "Hh", "<cmd>lua require('hop').hint_words()<CR>", desc = "Global Word" },
	{ "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "LSP Hover" },
	{ "[;", prev_qf_repeat, desc = "Prev Quickfix" },
	{ "[d", prev_diag_repeat, desc = "Prev Diagnostic" },
	{ "[h", prev_hunk_repeat, desc = "Prev Hunk" },
	{ "[p", require("harpoon.ui").nav_prev, desc = "Prev Harpoon" },
	{ "];", next_qf_repeat, desc = "Next Quickfix" },
	{ "]d", next_diag_repeat, desc = "Next Diagnostic" },
	{ "]h", next_hunk_repeat, desc = "Next Hunk" },
	{ "]p", require("harpoon.ui").nav_next, desc = "Next Harpoon" },
})

-- Experienced some weird behaviour if I'm opening Neogit from
-- a sub-folder in a repo. It would correctly detect the changes,
-- but any attempt to view the diff, stage, unstage or discard would fail
-- because it couldn't find the file.
-- This function will open Neogit using the Lua API, and specify the
-- current working directory as wherever we find the .git folder.
-- If no .git folder can be found, you'll see an error.
-- TODO: consider caching this, but right now you only see a small hit on opening of Neogit (and it
-- means if the CWD of the Neovim instance changes, you'll still be able to open Neogit there no problem).
local function search_for_repo()
	local git_paths = vim.fs.find(
		".git",
		{ upward = true, stop = vim.loop.os_homedir(), path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) }
	)

	if #git_paths > 0 then
		return vim.fs.dirname(git_paths[1])
	end
end

local function open_neogit()
	local git_path = search_for_repo()
	if git_path == nil then
		vim.notify("Failed to open Neogit: git repository not found", vim.log.levels.ERROR)
		return
	end

	vim.notify("Git repository found to be rooted at '" .. git_path .. "'", vim.log.levels.TRACE)
	require("neogit").open({ cwd = git_path })
end

-- Configure <leader> keymaps (default leader is space) in normal-mode
-- Specific keymaps for LSPs/languages may be set elsewhere (typically
-- in an LSPs onattach (see lsp/init.lua)
whichkey.add({
	{ "<leader>/", "<cmd>Commentary<CR>", desc = "Toggle Line Comment" },
	{ "<leader>;", "<cmd>Dashboard<CR>", desc = "Open Dashboard" },
	{ "<leader><leader>", "<cmd>nohlsearch<CR>", desc = "Clear Search Highlight" },
	{ "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal file in Tree" },
	{ "<leader>G", open_neogit, desc = "Neogit" },
	{ "<leader>e", "<cmd>Neotree<CR>", desc = "Open File Tree" },
	{ "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find File" },
	{ "<leader>g", group = "Git" },
	{ "<leader>gP", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
	{ "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
	{ "<leader>gb", "<cmd>GitBlameToggle<CR>", desc = "Toggle Blame" },
	{ "<leader>gc", "<cmd>Telescope git_branches<CR>", desc = "Checkout branch" },
	{ "<leader>gd", desc = "+Diff" },
	{ "<leader>gdH", "<CMD>DiffviewFileHistory<CR>", desc = "Full commit history" },
	{ "<leader>gdd", "<CMD>DiffviewOpen<CR>", desc = "Diff working tree" },
	{ "<leader>gdh", "<CMD>DiffviewFileHistory %<CR>", desc = "File commit history" },
	{ "<leader>gdo", "<CMD>DiffviewOpen origin/HEAD<CR>", desc = "Diff with origin" },
	{ "<leader>gdx", "<CMD>DiffviewClose<CR>", desc = "Close" },
	{ "<leader>gg", open_neogit, desc = "Neogit" },
	{ "<leader>gj", "<cmd>Gitsigns next_hunk<CR>", desc = "Next Hunk" },
	{ "<leader>gk", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev Hunk" },
	{ "<leader>go", "<cmd>Telescope git_status<CR>", desc = "Git status" },
	{ "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview Hunk Inline" },
	{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
	{ "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
	{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },
	{ "<leader>p", group = "Harpoon" },
	{ "<leader>p1", "<cmd> lua require('harpoon.ui').nav_file(1)<CR>", desc = "File 1" },
	{ "<leader>p2", "<cmd> lua require('harpoon.ui').nav_file(2)<CR>", desc = "File 2" },
	{ "<leader>p3", "<cmd> lua require('harpoon.ui').nav_file(3)<CR>", desc = "File 3" },
	{ "<leader>pa", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Add file" },
	{ "<leader>pm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Menu" },
	{ "<leader>pn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", desc = "Next" },
	{ "<leader>pp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", desc = "Previous" },
	{ "<leader>pr", "<cmd>lua require('harpoon.mark').rm_file()<CR>", desc = "Remove file" },
	{ "<leader>q", group = "Quickfix" },
	{ "<leader>qn", "<cmd>cnext<CR>", desc = "Next" },
	{ "<leader>qp", "<cmd>cprevious<CR>", desc = "Previous" },
	{ "<leader>qq", "<cmd>copen<CR>", desc = "Open" },
	{ "<leader>qx", "<cmd>cclose<CR>", desc = "Close" },
	{ "<leader>s", group = "Search" },
	{ "<leader>sD", "<cmd>Telescope lsp_workspace_diagnostics<CR>", desc = "Workspace Diagnostics" },
	{ "<leader>sM", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
	{ "<leader>sR", "<cmd>Telescope registers<CR>", desc = "Registers" },
	{ "<leader>sc", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme" },
	{ "<leader>sd", "<cmd>Telescope lsp_document_diagnostics<CR>", desc = "Document Diagnostics" },
	{ "<leader>sf", "<cmd>Telescope find_files<CR>", desc = "Find File" },
	{ "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help Tag" },
	{ "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Marks" },
	{ "<leader>sr", "<cmd>Telescope oldfiles<CR>", desc = "Open Recent File" },
	{ "<leader>st", "<cmd>Telescope live_grep<CR>", desc = "Text" },
	{ "<leader>t", group = "Testing" },
	{ "<leader>tF", "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>", desc = "Toggle file watch" },
	{
		"<leader>ta",
		"<cmd>lua require('neotest').run.attach(require('neotest').run.get_last_run())<CR>",
		desc = "Attach to tests",
	},
	{ "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", desc = "Run file tests" },
	{ "<leader>to", "<cmd>lua require('neotest').output.open()<CR>", desc = "Test output" },
	{ "<leader>ts", "<cmd>lua require('neotest').run.run()<CR>", desc = "Run single test" },
	{ "<leader>tt", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Toggle summary" },
})

-- t = {
-- 	name = "+Diagnostics",
-- 	t = { "<cmd>lua require('trouble').open()<CR>", "Open" },
-- 	w = { "<cmd>lua require('trouble').open('workspace_diagnostics')<CR>", "Workspace" },
-- 	d = { "<cmd>lua require('trouble').open('document_diagnostics')<CR>", "Document" },
-- 	q = { "<cmd>lua require('trouble').open('quickfix')<CR><cmd>cclose<CR>", "Quickfix" },
-- 	l = { "<cmd>lua require('trouble').open('loclist')<CR>", "Loclist" },
-- 	n = { "<cmd>lua require('trouble').next {}<CR>", "Next" },
-- 	p = { "<cmd>lua require('trouble').previous {}<CR>", "Previous" },
-- 	x = { "<cmd>lua require('trouble').close()<CR>", "Close" },
-- 	s = {
-- 		"<cmd>lua require('trouble').open{ mode='symbols', follow=true, auto_refresh=true}<CR>",
-- 		"Document Symbols",
-- 	},
-- },
-- TODO actually setup debugging, probably only for DAP <-> Metals
-- D = {
--     name = "+Debug",
--     b = { "<cmd>DebugToggleBreakpoint<CR>", "Toggle Breakpoint" },
--     c = { "<cmd>DebugContinue<CR>", "Continue" },
--     i = { "<cmd>DebugStepInto<CR>", "Step Into" },
--     o = { "<cmd>DebugStepOver<CR>", "Step Over" },
--     r = { "<cmd>DebugToggleRepl<CR>", "Toggle Repl" },
--     s = { "<cmd>DebugStart<CR>", "Start" }
-- },

-- Configure visual-mode leader-based mappings
whichkey.add({
	{
		mode = { "v" },
		{ "<leader>/", ":Commentary<CR>", desc = "Toggle Comment" },
		{ "<leader>g", group = "Git" },
		{ "<leader>gd", ":DiffviewFileHistory<CR>", desc = "Range Git History" },
	},
})
