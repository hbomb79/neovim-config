--[[
-- NeoVim configuration files. Handles plugin initialisation and configuration.
--
-- Notable plugins:
-- - zpack for plugin management using built-in 'vim.pack' (requires nvim >= 0.12)
-- - Mason for LSP and other tool installation
-- - Conform for formatting support
-- - nvim-lint for linting support
--
-- Written by Harry Felton (https://github.com/hbomb79). Freely distributable.
--]]

-- Base settings
require("settings")

-- Initialise language registry (see ./lua/langs/)
require("langs"):setup()

-- Load plugins
vim.pack.add({ "https://github.com/zuqini/zpack.nvim" })
require("zpack").setup()

-- Handles auto-updating configuration
require("confmanager")
