--[[
-- NeoVim configuration files. Handles plugin initialisation and configuration.
--
-- Notable plugins:
-- - Lazy.nvim for Plugin management
-- - Mason for LSP and other tool installation
-- - Conform for formatting support
-- - nvim-lint for linting support
--
-- Written by Harry Felton (https://github.com/hbomb79). Freely
-- distributable.
--]]

-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	print("lazy.nvim not present... downloading now...")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Handles auto-updating configuration
require("confmanager")

-- Base settings
require("settings")

-- Load languages
require("lsp"):initialise()

-- Load plugins
require("lazy").setup("plugins")
