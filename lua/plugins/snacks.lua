return {
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				---@type snacks.dashboard.Section[]
				sections = {
					{ pane = 1, section = "header", align = "center" },
					{
						pane = 1,
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						indent = 2,
						padding = 1,
					},
					{
						pane = 1,
						icon = " ",
						title = "Projects",
						section = "projects",
						indent = 2,
						padding = 1,
					},
					{
						pane = 1,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = { 10, 10 },
						ttl = 5 * 60,
						indent = 3,
					},
					-- { pane = 1, section = "startup", align = "center" },
				},
			},
		},
	},
}
