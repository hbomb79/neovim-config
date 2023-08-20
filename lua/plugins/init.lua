-- This file can store logic for conditional
-- plugin loading.

-- Open plugin manager
require "plugin-wrapper".open(vim.fn.stdpath("config") .. "/plugged")

-- Load base plugins
require "plugins.base"

-- Language plugins for various language types (e.g. svelte/go/ts/etc)
require "plugins.lang"

-- Load LSP/autocomplete/etc plugins. Comment this out if lag/problems occur
require "plugins.lsp"


-- Close manager once done loading plugins
require "plugin-wrapper".close()

