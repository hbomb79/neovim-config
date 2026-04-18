-- mini.nvim plugins, listed independently here to better enable
-- Lazy.nvim dependency management.
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
