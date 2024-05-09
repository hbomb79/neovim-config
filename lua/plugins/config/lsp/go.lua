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
	local p = override_config_paths[1]
	config = vim.json.decode(vim.fn.readblob(p))
	vim.notify("Gopls config override found at " .. p, vim.log.levels.TRACE)
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
