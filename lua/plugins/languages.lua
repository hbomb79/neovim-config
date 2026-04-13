-- Extract language specs from the LSP manager and inject them here so that Lazy.nvim loads them
return require("lsp"):get_lang_plugin_specs()
