return {
	{
		"tpope/vim-sensible",
	},
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"tpope/vim-commentary",
		cmd = "Commentary",
	},
	{
		"ThePrimeagen/harpoon",
		opts = { menu = { width = 120 } },
		lazy = true,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
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
	},
	{
		"phaazon/hop.nvim",
		opts = { keys = "etovxqpdygfblzhckisuran" },
		branch = "v2",
		lazy = true,
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
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undo tree" },
		},
	},
	{
		"tris203/precognition.nvim",
	},
	{
		"kevinhwang91/nvim-bqf",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "junegunn/fzf", build = "./install --bin" },
		},
		config = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		keys = { "ys", "ds", "cs" },
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = true,
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
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
				{ "<leader>c", group = "Multi Cursor" },
				{ "<leader>cc", mc.toggleCursor, desc = "Toggle" },
				{
					"<leader>ca",
					mc.addCursorOperator,
					desc = "Operator",
				},
				{
					"<leader>ck",
					function()
						mc.lineAddCursor(-1)
					end,
					desc = "Up",
				},
				{
					"<leader>cj",
					function()
						mc.lineAddCursor(1)
					end,
					desc = "Down",
				},

				{
					"<leader>cn",
					function()
						mc.matchAddCursor(1)
					end,
					desc = "Match Next",
				},
				{
					"<leader>cN",
					function()
						mc.matchAddCursor(-1)
					end,
					desc = "Match Prev",
				},
				{
					"<leader>cs",
					function()
						mc.matchSkipCursor(1)
					end,
					desc = "Skip Match Next",
				},
				{
					"<leader>cS",
					function()
						mc.matchSkipCursor(-1)
					end,
					desc = "Skip Match Prev",
				},

				{
					"<leader>cr",
					mc.restoreCursors,
					desc = "Restore",
				},
				{
					"<leader>cA",
					mc.searchAllAddCursors,
					desc = "Add for search results",
				},
				{
					"<leader>cd",
					addCursorEveryDiagnostic,
					desc = "Diagnostics",
				},
			})

			require("which-key").add({
				{ "<leader>c", mc.addCursorOperator, mode = "v", desc = "Spawn cursors" },
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
}
