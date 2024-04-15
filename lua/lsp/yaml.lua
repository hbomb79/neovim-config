require "lsp":set_handler("spectral", function(_, _)
    return { auto_hover = false, auto_format = false }
end)

require "lspconfig".spectral.setup {}
require "lsp":notify_new_lsp()
