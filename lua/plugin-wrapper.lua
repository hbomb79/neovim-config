--[[
-- This script helps us use Vim-Plug inside of a Lua
-- environment, and allows us to specify configration
-- and Lua functions to run after successfully loading
-- the plugins
--
-- Include this script in your main configuration to allow
-- for easy specification of plugins and their relevant config
--]]

local function parsePluginName(repo)
    if not repo:find("/") then
        return repo:sub(".nvim$", "")
    end

    return repo:gsub(".*/(.+)", "%1"):gsub(".nvim$", "")
end

local function isModuleAvailable(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

local loadedPlugins = {}
local callbacks = {
    always = {},
    lazy = {}
}

local meta = {
    __call = function(self, opts)
        local repo = ""
        if type(opts) == "table" then
            repo = opts[1]
            table.remove(opts, 1)
        elseif type(opts) == "string" then
            repo = opts
            opts = vim.empty_dict()
        end

        -- we declare some aliases for `do` and `for`
        opts['do'] = opts.run
        opts.run = nil

        opts['for'] = opts.ft
        opts.ft = nil

        vim.call('plug#', repo, opts)
        loadedPlugins[parsePluginName(repo)] = true

        if type(opts.config) == 'function' then
            local plugin = opts.as or repo

            if opts['for'] == nil and opts.on == nil then
                callbacks.always[plugin] = opts.config
            else
                callbacks.lazy[plugin] = opts.config

                local user_cmd = "autocmd! User %s ++once lua VimPlugApplyConfig('%s')"
                vim.cmd(user_cmd:format(plugin, plugin))
            end
        end
    end
}

local plug = setmetatable({
    -- open accepts the configPath that the underlying
    -- plugin manager (Vim-Plug) will use.
    open = function(configPath)
        if not configPath or configPath == "" then
            return error("Cannot 'open' plugin manager - missing configPath")
        end

        vim.fn["plug#begin"](configPath)
    end,

    -- close is used to call the underlying plugin manager
    -- finish function, *and* to run all plugin 'post load' hooks, as well as 'config' callbacks
    -- for plugins. This is done here so that if config
    -- depends on other plugins, they will be able to find eachother
    close = function()
        vim.fn["plug#end"]()

        --TODO Lazy config
        for k, _ in pairs(loadedPlugins) do
            if isModuleAvailable("plugins.post_load_hook." .. k) then
                local ok, err = pcall(require, "plugins.post_load_hook."..k)
                if not ok then
                    print("[Error] Post load hook for plugin " .. k .. " crashed: " .. err)
                end
            end
        end

        for k, v in pairs(callbacks.always) do
            if type(v) == "function" then
                v()
            else
                print("Warning: callback for plugin '" .. k .. "' is of invalid type (expected function, not '" .. type(v) .. "')")
            end
        end
    end
}, meta)

return plug
