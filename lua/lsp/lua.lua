require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        local lazypath = vim.fn.stdpath("data") .. "/lazy/*/lua"
        local pluginLibs = vim.api.nvim_get_runtime_file(lazypath, true)

        client.config.settings.Lua.workspace.library = pluginLibs
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        return true
    end
}
