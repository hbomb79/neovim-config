return {
	options = {
		theme = "catppuccin",
		component_separators = "",
		section_separators = { left = "", right = "" },
		ignore_focus = { "neo-tree", "NeogitStatus" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
		lualine_b = { "filename", "branch" },
		lualine_c = {
			{
				function()
					local clients = vim.lsp.get_active_clients()
					if next(clients) == nil then
						return "No LSP"
					end

					local matching_clients = {}
					local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							table.insert(matching_clients, client.name)
						end
					end

					if #matching_clients == 0 then
						return "No LSP"
					end

					return table.concat(matching_clients, "|")
				end,
				icon = "",
			},
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
}
