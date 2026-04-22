return {
	-- Light overview of plugins installed/loaded via zpack.
	{
		"sairyy/zshow.nvim",
		opts = {},
	},

	-- Keymap helper. Displays at the bottom right of the screen and shows
	-- next possible keys.
	{
		"folke/which-key.nvim",
		opts = { preset = "helix" },
	},

	-- Allows pinning of files for quick switching between them.
	{
		"ThePrimeagen/harpoon",
		opts = { menu = { width = 120 } },
		keys = {
			{ "<leader>p", desc = "Harpoon" },
			{ "<leader>p1", "<cmd> lua require('harpoon.ui').nav_file(1)<CR>", desc = "File 1" },
			{ "<leader>p2", "<cmd> lua require('harpoon.ui').nav_file(2)<CR>", desc = "File 2" },
			{ "<leader>p3", "<cmd> lua require('harpoon.ui').nav_file(3)<CR>", desc = "File 3" },
			{ "<leader>pa", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Add file" },
			{ "<leader>pm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Menu" },
			{ "<leader>pn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", desc = "Next" },
			{ "<leader>pp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", desc = "Previous" },
			{ "<leader>pr", "<cmd>lua require('harpoon.mark').rm_file()<CR>", desc = "Remove file" },
		},
	},

	-- Tweaks the standard LSP rename UX by displaying the prompt AT the
	-- identifier being renamed, rather than on the cmdline.
	{
		"filipdutescu/renamer.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		opts = { min_width = 40, max_width = 50 },
	},

	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			filesystem = {
				use_libuv_file_watcher = true,
			},
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
		keys = {
			{ "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal file in Tree" },
			{ "<leader>e", "<cmd>Neotree last<CR>", desc = "Open File Tree" },
		},
	},

	-- Quick way to hop around lines (with <leader>hh) or around the entire file (with <leader>hH)
	{
		"smoka7/hop.nvim",
		opts = { keys = "etovxqpdygfblzhckisuran" },
		sem_version = "*",
		keys = {
			{ "<leader>h", nil, desc = "Hop" },
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
		},
	},

	-- Improve the standard vim notify by showing the messages in the top right
	-- of the screen.
	{
		"rcarriga/nvim-notify",
		priority = 1000,
		config = function()
			vim.notify = require("notify")
			vim.notify_once = require("notify")
		end,
	},

	-- Allows interaction with the built-in undo tree. This plugin isn't strictly required
	-- anymore, but it has some nice QoL improvements when compared to the native UI.
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		opts = {},
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undo tree" },
		},
	},

	-- Improve the quickfix experience. Most notable is the preview window that appears when cycling
	-- through items in the list (for example, when looking at LSP references).
	{
		"kevinhwang91/nvim-bqf",
		ft = { "qf" },
		keys = {
			{ "<leader>q", desc = "Quickfix" },
			{ "<leader>qp", "<cmd>cprevious<CR>", desc = "Previous" },
			{ "<leader>qn", "<cmd>cnext<CR>", desc = "Next" },
			{ "<leader>qq", "<cmd>copen<CR>", desc = "Open" },
			{ "<leader>qx", "<cmd>cclose<CR>", desc = "Close" },
		},
	},

	-- Allows adding/changing syntax surrounding words/motions. For example, ysiw< will change `hello`
	-- to `< hello >`. Or, cs"' will change `"hello"` to `'hello'`.
	{
		"kylechui/nvim-surround",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {},
		sem_version = "^4.0.0",
		event = "VeryLazy",
	},

	-- Provides multi cursor functionality.
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		event = "VeryLazy",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			-- Multi-cursor action which adds a cursor at each diagnostic found
			-- in the current buffer. Clears all existing cursors.
			local addCursorEveryDiagnostic = function(opts)
				local diagnostics = vim.diagnostic.get(0, opts)

				mc.action(function(ctx)
					local mainCursor = ctx:mainCursor()
					-- Clear existing cursors
					ctx:forEachCursor(function(cursor)
						if cursor ~= mainCursor then
							cursor:delete()
						end
					end)

					-- Spawn a cursor at each diagnostic
					for _, d in ipairs(diagnostics) do
						-- diagnostic is 0-based line and col
						local newCursor = mainCursor:clone()
						newCursor:setPos({ d.lnum + 1, d.col + 1 })
						newCursor:setMode("n")
					end
					mainCursor:delete()
				end)
			end

			require("which-key").add({
				{ "<leader>C", group = "Multi Cursor" },
				{ "<leader>CC", mc.toggleCursor, desc = "Toggle" },
				{
					"<leader>Ca",
					mc.addCursorOperator,
					desc = "Operator",
				},
				{
					"<leader>Ck",
					function()
						mc.lineAddCursor(-1)
					end,
					desc = "Up",
				},
				{
					"<leader>Cj",
					function()
						mc.lineAddCursor(1)
					end,
					desc = "Down",
				},

				{
					"<leader>Cn",
					function()
						mc.matchAddCursor(1)
					end,
					desc = "Match Next",
				},
				{
					"<leader>CN",
					function()
						mc.matchAddCursor(-1)
					end,
					desc = "Match Prev",
				},
				{
					"<leader>Cs",
					function()
						mc.matchSkipCursor(1)
					end,
					desc = "Skip Match Next",
				},
				{
					"<leader>CS",
					function()
						mc.matchSkipCursor(-1)
					end,
					desc = "Skip Match Prev",
				},
				{
					"<leader>Cr",
					mc.restoreCursors,
					desc = "Restore",
				},
				{
					"<leader>C/",
					mc.searchAllAddCursors,
					desc = "Add at search results",
				},
				{
					"<leader>Cd",
					addCursorEveryDiagnostic,
					desc = "Diagnostics",
				},

				{ "<leader>C", mc.addCursorOperator, mode = "v", desc = "Spawn cursors" },
			})

			-- Add and remove cursors with control + left click.
			vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
			vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
			vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)

			-- Mappings defined in a keymap layer only apply when there are
			-- multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Select a different cursor as the main one.
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)

				-- Delete the main cursor.
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

			-- Customize how cursors look.
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { reverse = true })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { reverse = true })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},

	-- Filesystem modification inside of Neovim by yanking/deleting/pasting. Access using :Oil
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },

		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
	},

	-- Subtle scrollbar on the right side of the buffer which shows what is visible, git
	-- changes, and LSP diagnostics
	{
		"petertriho/nvim-scrollbar",
		event = "VeryLazy",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			{ "kevinhwang91/nvim-hlslens", opts = {} },
		},
		config = function()
			local colors = require("catppuccin.palettes").get_palette()

			require("scrollbar").setup({
				handle = {
					blend = 40,
					color = colors.surface1,
				},
				marks = {
					Cursor = {
						text = "-",
					},
					-- Use same signs as diagnostic signs. Refer to lsp.lua
					Error = { text = { "" }, color = colors.red },
					Warn = { text = { "" }, color = colors.peach },
					Info = { text = { "" }, color = colors.lavender },
					Hint = { text = { "" }, color = colors.teal },

					-- Use same signs as gitsigns in the signcolumn
					GitAdd = { text = "│", color = colors.green },
					GitChange = { text = "│", color = colors.yellow },
					GitDelete = { text = "-", color = colors.red },
				},
				handlers = {
					gitsigns = true,
					search = true,
				},
				excluded_filetypes = {
					"snacks_dashboard",
					"neo-tree",
					"neotest-summary",
				},
			})
		end,
	},
}
