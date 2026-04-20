require("langs"):add_spec({
	ft = { "markdown" },

	plugins = {
		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			keys = {},
			build = function()
				vim.fn["mkdp#util#install"]()
			end,
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
				vim.g.mkdp_auto_close = 0
				vim.g.mkdp_theme = "dark"
			end,
		},
	},

	on_load = function()
		-- Create buffer specific keymap to toggle markdown preview via autocmd.
		-- Only bound for buffers of filetype=markdown.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(ev)
				vim.keymap.set(
					"n",
					"<leader>mp",
					"<cmd>MarkdownPreviewToggle<CR>",
					{ buf = ev.buf, desc = "Toggle Markdown Preview" }
				)
			end,
		})
	end,
})
