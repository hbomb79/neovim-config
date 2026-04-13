-- Register Elixir support. Auto-installs ElixirLS via Mason
require("lsp"):add_spec({
	ft = { "elixir" },
	mason_auto_install = { "elixir-ls" },

	plugins = {
		{
			"elixir-tools/elixir-tools.nvim",
			config = function()
				vim.g.elixirnvim_has_prompted_for_install = true
				require("elixir").setup({
					elixirls = {
						enable = true,
						settings = require("elixir.elixirls").settings({
							dialyzerEnabled = true,
							enableTestLenses = true,
							suggestSpecs = true,
						}),
						on_attach = function(_, bufnr)
							vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = bufnr, noremap = true })
							vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = bufnr, noremap = true })
							vim.keymap.set(
								"v",
								"<space>em",
								":ElixirExpandMacro<cr>",
								{ buffer = bufnr, noremap = true }
							)
						end,
					},
					projectionist = {
						enable = false,
					},
				})
			end,
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
	},

	on_load = function()
		vim.lsp.config("elixirls", {
			cmd = { vim.fn.expand("$MASON/packages/elixir-ls/language_server.sh") },
		})

		require("lsp"):set_handler("ElixirLS", function(_, _)
			return { auto_hover = false }
		end)
	end,
})
