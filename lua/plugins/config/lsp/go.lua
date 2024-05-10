local config = {
	analyses = {
		unusedparams = true,
	},
	staticcheck = true,
	gofumpt = true,
}

local override_config_paths = vim.fs.find(".gopls.json", {
	upward = true,
	stop = vim.loop.os_homedir(),
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
require("lspconfig").gopls.setup({
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
	settings = { gopls = config },
})
require("lsp"):notify_new_lsp()
