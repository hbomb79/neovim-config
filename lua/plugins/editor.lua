return {
	{
		"sairyy/zshow.nvim",
		opts = {},
	},
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
	{
		"filipdutescu/renamer.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		opts = { min_width = 40, max_width = 50 },
	},
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
	{
		"rcarriga/nvim-notify",
		priority = 1000,
		config = function()
			vim.notify = require("notify")
			vim.notify_once = require("notify")
		end,
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		opts = {},
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undo tree" },
		},
	},
	{
		"kevinhwang91/nvim-bqf",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		ft = { "qf" },
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"kylechui/nvim-surround",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {},
		sem_version = "^4.0.0",
		event = "VeryLazy",
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		event = "VeryLazy",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local set = vim.keymap.set

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
			})

			require("which-key").add({
				{ "<leader>C", mc.addCursorOperator, mode = "v", desc = "Spawn cursors" },
			})
			-- Add and remove cursors with control + left click.
			set("n", "<c-leftmouse>", mc.handleMouse)
			set("n", "<c-leftdrag>", mc.handleMouseDrag)
			set("n", "<c-leftrelease>", mc.handleMouseRelease)

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
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_close = 0
			vim.g.mkdp_theme = "dark"
		end,
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },

		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
	},
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
				},
			})
		end,
	},
}
