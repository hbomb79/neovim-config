local lsp_info = function()
	-- Find all LSP clients attached to current buffer
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	if #clients == 0 then
		return "No LSP"
	end

	-- If > 0 clients attached, concat the names together.
	local client_names = {}
	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
	end
	return table.concat(client_names, " :: ")
end

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				component_separators = "",
				section_separators = { left = "", right = "" },
				ignore_focus = { "neo-tree", "NeogitStatus", "neotest-summary", "qf" },
				disabled_filetypes = { "neo-tree", "NeogitStatus", "neotest-summary", "qf" },
				globalstatus = true,
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = { "filename", "branch" },
				lualine_c = {
					-- LSP status
					{ lsp_info, icon = "" },
					"diagnostics",
					"%=", -- centers all that follows
				},
				lualine_x = {
					"diff",
				},
				lualine_y = { "filetype", "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {},
			extensions = {},
		},
	},
}
