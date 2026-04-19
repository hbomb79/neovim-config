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

-- Load zpack for plugin management
vim.pack.add({ "https://github.com/zuqini/zpack.nvim" })

-- Monkey-patch zpacks 'apply_keys' function to detect keymaps with no
-- 'RHS' and map them to <NOP> rather than just skipping them. Without
-- this, which_key gets confused sometimes and the group loses its label.
--
-- Caution: This will likely break with zpack updates. Should be trivial to
-- resolve if/when it does
--
---@diagnostic disable-next-line: duplicate-set-field
require("zpack.keymap").apply_keys = function(keys)
	local key_list = require("zpack.utils").normalize_keys(keys) --[[@as zpack.KeySpec[] ]]

	for _, key in ipairs(key_list) do
		-- Unlike the original implementation, don't SKIP keys with no/nil rhs.
		local rhs = key[2] or "<NOP>"
		require("zpack.keymap").map(key[1], rhs, key.remap, key.desc, key.mode, key.nowait)
	end
end

-- Load plugins
require("zpack").setup()

-- Handles auto-updating configuration
require("confmanager")
