-- Register Rust support. Rust LSP should be provided externally to NeoVim
-- as part of the standard Rust toolchain, so we just manually enable the LSP
require("lsp"):add_spec({
	ft = { "rust" },
	on_load = function()
		vim.lsp.enable("rust_analyzer")
	end,
})
