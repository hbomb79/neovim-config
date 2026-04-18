-- Register OCaml support. Auto installs ocaml-lsp, and applies some buffer-specific overrides
require("langs"):add_spec({
	ft = { "ocaml" },
	mason_auto_install = { "ocaml-lsp" },

	plugins = {
		{
			"tjdevries/ocaml.nvim",
			config = function()
				require("ocaml").update()
				require("ocaml").setup()
			end,
		},
	},

	on_load = function()
		vim.lsp.config("ocamllsp", {
			ocamllsp = {
				get_language_id = function(_, ftype)
					return ftype
				end,
			},
		})

		require("langs"):set_handler("ocamllsp", function(_, bufnr)
			vim.bo[bufnr].shiftwidth = 2
			vim.bo[bufnr].tabstop = 2
		end)
	end,
})
