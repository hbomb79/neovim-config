local ok, mason_registry = pcall(require, "mason-registry")
if not ok then
	vim.notify("mason-registry could not be loaded", vim.log.levels.ERROR)
	return
end

local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()

local cmd = {
	"ngserver",
	"--stdio",
	"--tsProbeLocations",
	table.concat({
		angularls_path,
		vim.loop.cwd(),
	}, ","),
	"--ngProbeLocations",
	table.concat({
		angularls_path .. "/node_modules/@angular/language-server",
		vim.loop.cwd(),
	}, ","),
}

---- Register custom on_attach behaviour for Angular as the language server
---- exposes some specific keybindings we'd like to use. We still want the
---- standard 'common' on_attach though.
require("lsp"):set_handler(
	"angularls",
	---@param buffer number
	function(_, buffer)
		require("which-key").register({
			name = "Angular",
			["t"] = { "<CMD>lua require('ng').goto_template_for_component()<CR>", "Go to Template" },
			["c"] = { "<CMD>lua require('ng').goto_component_with_template_file()<CR>", "Go to component templ file" },
			["T"] = { "<CMD>lua require('ng').get_template_tcb()<CR>", "Get template TCB" },
		}, { prefix = "<leader>a", buffer = buffer })

		return { auto_hover = false, whichkey_binding = true }
	end
)

require("lspconfig").angularls.setup({
	cmd = cmd,
	on_new_config = function(new_config, _)
		new_config.cmd = cmd
	end,
	root_dir = require("lspconfig.util").root_pattern("angular.json"),
})

require("lsp"):notify_new_lsp()
