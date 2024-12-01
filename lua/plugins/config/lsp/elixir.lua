require("lspconfig").lexical.setup({})
require("lsp"):set_handler(
	"lexical",
	---@param client lsp.Client
	function(_, _)
		return { auto_hover = false }
	end
)
require("lsp"):notify_new_lsp()
