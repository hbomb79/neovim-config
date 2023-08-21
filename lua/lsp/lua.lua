require("neodev").setup {}
require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        local pluginLibs = vim.api.nvim_get_runtime_file("plugged/*/lua", true)
        client.config.settings.Lua.workspace.library = pluginLibs
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        return true
    end

}
