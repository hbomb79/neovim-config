-- Register YAML support. Auto-installs spectral via Mason and disables auto_hover
require("lsp"):add_spec({
	ft = { "yaml" },
	mason_auto_install = { "spectral-language-server" },

	on_load = function()
		require("lsp"):set_handler("spectral", function(_, _)
			return { auto_hover = false }
		end)
	end,
})
