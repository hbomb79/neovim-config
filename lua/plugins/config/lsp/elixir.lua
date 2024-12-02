require("lspconfig").elixirls.setup({})
require("lsp"):set_handler(
	"elixirls",
	---@param client lsp.Client
	function(_, _)
		return { auto_hover = false }
	end
)
require("lsp"):notify_new_lsp()
