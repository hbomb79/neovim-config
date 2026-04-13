-- Register Go LSP. LSP is installed outside of NeoVim/Mason because
-- it is part of the standard Go toolchain. As such, all we want to do
-- is run some code to tweak the behaviour.
--
-- Note: The Go tools are excluded from Mason 'ensure_installed'
require("lsp"):add_spec({
	ft = { "go", "gomod" },

	linters = { "golangcilint" },

	on_load = function()
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
			---@diagnostic disable-next-line: param-type-mismatch
			config = vim.json.decode(vim.fn.readblob(path))
			vim.notify("Gopls config override found at " .. path, vim.log.levels.TRACE)
		else
			vim.notify("No Gopls config override found, using default", vim.log.levels.TRACE)
		end

		vim.notify("Setting up gopls LSP with config: " .. vim.inspect(config), vim.log.levels.TRACE)
		vim.lsp.config("gopls", {
			cmd = { "gopls", "serve" },
			filetypes = { "go", "gomod" },
			root_markers = { "go.mod", "go.work", ".git" },
			settings = { gopls = config },
		})
		vim.lsp.enable("gopls")

		-- Disable max same issues check as this can hide issues when the maximum
		-- of that issue type was detected in a different file in the same package.
		table.insert(require("lint").linters["golangcilint"].args, 2, "--max-same-issues=0")
	end,
})
