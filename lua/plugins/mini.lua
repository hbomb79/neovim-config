-- mini.nvim plugins
return {
	{ "nvim-mini/mini.cmdline", opts = {
		autocorrect = { enable = false },
	} },
	{
		"nvim-mini/mini.icons",
		opts = {},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
}
