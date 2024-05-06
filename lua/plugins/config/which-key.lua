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
whichkey.register({
	["<S-x>"] = { "<cmd>bdelete<CR>", "" },
	["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev Diagnostic" },
	["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
	["[;"] = { "<cmd>cprevious<CR>", "Prev Quickfix" },
	["];"] = { "<cmd>cnext<CR>", "Next Quickfix" },
	K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP Hover" },
	H = {
		name = "+Hop",
		h = { "<cmd>lua require('hop').hint_words()<CR>", "Global Word" },
		H = { "<cmd>lua require('hop').hint_words {current_line_only = true}<CR>", "Line Word" },
		c = { "<cmd>lua require('hop').hint_char1 {current_line_only = false}<CR>", "Global Char" },
		C = { "<cmd>lua require('hop').hint_char1 {current_line_only = true}<CR>", "Line Char" },
	},
})

-- Configure <leader> keymaps (default leader is space) in normal-mode
-- Specific keymaps for LSPs/languages may be set elsewhere (typically
-- in an LSPs onattach (see lsp/init.lua)
whichkey.register({
	["<leader>"] = { "<cmd>nohlsearch<CR>", "Clear Search Highlight" },
	["/"] = { "<cmd>Commentary<CR>", "Toggle Line Comment" },
	["e"] = { "<cmd>Neotree<CR>", "Open File Tree" },
	["E"] = { "<cmd>Neotree reveal<CR>", "Reveal file in Tree" },
	["f"] = { "<cmd>Telescope find_files<CR>", "Find File" },
	[";"] = { "<cmd>Dashboard<CR>", "Open Dashboard" },
	q = {
		name = "+Quickfix",
		q = { "<cmd>copen<CR>", "Open" },
		x = { "<cmd>cclose<CR>", "Close" },
		n = { "<cmd>cnext<CR>", "Next" },
		p = { "<cmd>cprevious<CR>", "Previous" },
	},
	G = { ":Neogit<CR>", "Neogit" },
	g = {
		name = "+Git",
		g = { ":Neogit<CR>", "Neogit" },
		j = { "<cmd>Gitsigns next_hunk<CR>", "Next Hunk" },
		k = { "<cmd>Gitsigns prev_hunk<CR>", "Prev Hunk" },
		P = { "<cmd>Gitsigns preview_hunk<CR>", "Preview Hunk" },
		p = { "<cmd>Gitsigns preview_hunk_inline<CR>", "Preview Hunk Inline" },
		r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
		R = { "<cmd>Gitsigns reset_buffer<CR>", "Reset Buffer" },
		s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
		u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk" },
		d = {
			"+Diff",
			d = { "<CMD>DiffviewOpen<CR>", "Diff working tree" },
			o = { "<CMD>DiffviewOpen origin/HEAD<CR>", "Diff with origin" },
			h = { "<CMD>DiffviewFileHistory %<CR>", "File commit history" },
			H = { "<CMD>DiffviewFileHistory<CR>", "Full commit history" },
			x = { "<CMD>DiffviewClose<CR>", "Close" },
		},
		o = { "<cmd>Telescope git_status<CR>", "Git status" },
		c = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
		b = { "<cmd>GitBlameToggle<CR>", "Toggle Blame" },
	},
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
	p = {
		name = "+Harpoon",
		a = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add file" },
		r = { "<cmd>lua require('harpoon.mark').rm_file()<CR>", "Remove file" },
		m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" },
		n = { "<cmd>lua require('harpoon.ui').nav_next()<CR>", "Next" },
		p = { "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "Previous" },
		["1"] = { "<cmd> lua require('harpoon.ui').nav_file(1)<CR>", "File 1" },
		["2"] = { "<cmd> lua require('harpoon.ui').nav_file(2)<CR>", "File 2" },
		["3"] = { "<cmd> lua require('harpoon.ui').nav_file(3)<CR>", "File 3" },
	},
	s = {
		name = "+Search",
		c = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
		d = { "<cmd>Telescope lsp_document_diagnostics<CR>", "Document Diagnostics" },
		D = { "<cmd>Telescope lsp_workspace_diagnostics<CR>", "Workspace Diagnostics" },
		f = { "<cmd>Telescope find_files<CR>", "Find File" },
		m = { "<cmd>Telescope marks<CR>", "Marks" },
		M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
		h = { "<cmd>Telescope help_tags<CR>", "Help Tag" },
		r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
		R = { "<cmd>Telescope registers<CR>", "Registers" },
		t = { "<cmd>Telescope live_grep<CR>", "Text" },
	},
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
}, { prefix = "<leader>" })

-- Configure visual-mode leader-based mappings
whichkey.register({
	["/"] = { ":Commentary<CR>", "Toggle Comment" },
	g = {
		name = "+Git",
		d = { ":DiffviewFileHistory<CR>", "Range Git History" },
	},
}, { prefix = "<leader>", mode = "v" })
