-- Extract language specs from the LSP manager and inject them here so that Lazy.nvim loads them
return require("langs"):get_plugin_specs()
