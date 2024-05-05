--[[
-- NeoVim configuration files. Handles plugin initialisation and configuration
-- using Vim-Plug and some basic Vim-based configuration.
--
-- Written by Harry Felton (https://github.com/hbomb79). Freely
-- distributable.
--]]

-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("settings")
require("lsp"):initialise()
require("lazy").setup("plugins")
require("lang")

require("confmanager")
