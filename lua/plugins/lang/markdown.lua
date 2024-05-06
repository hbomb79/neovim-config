return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown", "md" },
		config = function()
			require("nvim-treesitter.install").ensure_installed_sync("markdown")
		end,
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
