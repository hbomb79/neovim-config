local enabled = false
local function enable_gopls()
	if enabled then
		return
	end
	enabled = true

	-- Default configuration
	local config = {
		analyses = {
			unusedparams = true,
		},
		staticcheck = true,
		gofumpt = true,
	}

	-- Search for a user-created config file.
	local override_config_paths = vim.fs.find(".gopls.json", {
		upward = true,
		stop = vim.uv.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})

	-- If config file is found, use that instead of the default
	if #override_config_paths > 0 then
		local path = override_config_paths[1]
		vim.notify("Gopls config override found at " .. path .. ". Merging with default config", vim.log.levels.TRACE)

		local override = vim.json.decode(vim.fn.readblob(path))
		config = vim.tbl_extend("force", config, override)
	else
		vim.notify("No Gopls config override found, using default", vim.log.levels.TRACE)
	end

	vim.notify("Setting up gopls LSP with config: " .. vim.inspect(config), vim.log.levels.TRACE)
	vim.lsp.config("gopls", {
		root_markers = { "go.mod", "go.work", ".git" },
		settings = { gopls = config },
	})
	vim.lsp.enable("gopls")
end

-- Register Go LSP. LSP is installed outside of NeoVim/Mason because
-- it is part of the standard Go toolchain. As such, all we want to do
-- is run some code to tweak the behaviour.
--
-- Note: The Go tools are excluded from Mason 'ensure_installed'
require("langs"):add_spec({
	ft = { "go" },

	linters = { "golangcilint" },

	on_load = function()
		enable_gopls()

		-- Disable max same issues check as this can hide issues when the maximum
		-- of that issue type was detected in a different file in the same package.
		table.insert(require("lint").linters["golangcilint"].args, 2, "--max-same-issues=0")
	end,

	neotest = {
		dependencies = {
			{
				"fredrikaverpil/neotest-golang",
				build = function()
					vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
				end,
			},
		},
		adapter = function()
			return require("neotest-golang")({
				runner = "gotestsum",
				go_test_args = { "-count=1", "-tags=integration" }, --cache busting
				warn_test_name_dupes = false,
			})
		end,
	},
})

-- Also register the gomod/gosum languages to ensure Treesitter parsers
-- are auto-installed and started.
require("langs"):add_spec({ ft = { "gomod" }, on_load = enable_gopls })
require("langs"):add_spec({ ft = { "gosum" } })
