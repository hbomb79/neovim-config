local config = {
	analyses = {
		unusedparams = true,
	},
	staticcheck = true,
	gofumpt = true,
}

local override_config_paths = vim.fs.find(".gopls.json", {
	upward = true,
	stop = vim.uv.os_homedir(),
	path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
})

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
