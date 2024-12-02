--require("lsp"):set_handler(
--	"ElixirLS",
--	---@param client lsp.Client
--	function(_, _)
--		return { auto_hover = false }
--	end
--)
require("lsp"):set_handler(
	"Next LS",
	---@param client lsp.Client
	function(_, _)
		return { auto_hover = false }
	end
)
require("lsp"):notify_new_lsp()
