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

require("settings")

-- Language initialisation. This NeoVim configuration uses a centralized registry
-- to store all language specific 'specifications'.
-- These specifications contain the plugins, linters, formatters, etc. Refer to the
-- LangSpec type for more information
---@see LangSpec
local lsp = require("lsp")
lsp:add_specs({

	-- Register Lua
	{
		ft = { "lua" },
		formatters = { "stylua" },
		mason_auto_install = { "lua-language-server" },
		plugins = "AUTO",
	},

	-- Register Go LSP. LSP is installed outside of NeoVim/Mason because
	-- it is part of the standard Go toolchain. As such, all we want to do
	-- is run some code to tweak the behaviour.
	--
	-- Note: The Go tools are excluded from Mason 'ensure_installed'
	{
		ft = { "go", "gomod" },
		linters = { "golangcilint" },
		post_load_hook = "AUTO",
	},

	-- Register Scala language tools. Some fairly extensive bootstrapping occurs
	-- in the post load hook, mainly to fix a bug which broke diagnostics.
	-- TODO: investigate if this fix is still required.
	{
		ft = { "scala", "sbt" },
		plugins = "AUTO",
		post_load_hook = "AUTO",
	},

	-- Register specs for front-end web development (via Angular). This registers both
	-- Typescript and Angular plugins/lsps.

	{
		ft = { "typescript", "javascript" },
		formatters = { "prettierd" },
		plugins = "AUTO",
		post_load_hook = "AUTO",
	},
	{
		name = "angular",
		ft = { "typescript", "htmlangular" },
		formatters = { "prettierd" },
		mason_auto_install = { "angular-language-server" },
		plugins = "AUTO",
		post_load_hook = "AUTO",
	},

	-- Register Elixir support
	{
		ft = { "elixir" },
		plugins = "AUTO",
		mason_auto_install = { "elixir-ls" },
		post_load_hook = function()
			vim.lsp.config("elixirls", {
				cmd = { vim.fn.expand("$MASON/packages/elixir-ls/language_server.sh") },
			})

			lsp:set_handler("ElixirLS", function(_, _)
				return { auto_hover = false }
			end)
		end,
	},

	-- Register OCaml support. Auto installs ocaml-lsp, and applies some buffer-specific overrides
	{
		ft = { "ocaml" },
		plugins = "AUTO",
		mason_auto_install = { "ocaml-lsp" },
		post_load_hook = function()
			vim.lsp.config("ocamllsp", {
				ocamllsp = {
					get_language_id = function(_, ftype)
						return ftype
					end,
				},
			})

			lsp:set_handler("ocamllsp", function(_, bufnr)
				vim.bo[bufnr].shiftwidth = 2
				vim.bo[bufnr].tabstop = 2
			end)
		end,
	},

	-- Register Bash support. Auto-installs bashls.
	{
		ft = { "bash", "sh" },
		mason_auto_install = { "bash-language-server" },
	},

	-- Register Rust support. Rust LSP provides externally to NeoVim, so manually enable
	{
		ft = { "rust" },
		post_load_hook = function()
			vim.lsp.enable("rust_analyzer")
		end,
	},

	-- Register SQL support. Auto-installs sqlfluff linter.
	{
		ft = { "sql" },
		linters = { "sqlfluff" },
		mason_auto_install = { "sqlfluff" },
		post_load_hook = function()
			-- Override default sqlfluff behaviour
			local sqlfluff = require("lint").linters.sqlfluff
			sqlfluff.cmd = vim.fn.expand("$MASON/bin/sqlfluff")
			sqlfluff.args = { "lint", "--dialect", "postgres", "--format=json", "-" }
		end,
	},

	-- Register YAML support. Auto-installs spectral via Mason and disables auto_hover
	{
		ft = { "yaml" },
		mason_auto_install = { "spectral-language-server" },
		post_load_hook = function()
			lsp:set_handler("spectral", function(_, _)
				return { auto_hover = false }
			end)
		end,
	},
})

lsp:initialise()

require("lazy").setup("plugins")

-- Handles auto-updating configuration
require("confmanager")
