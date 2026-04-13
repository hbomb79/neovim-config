-- Register spec for front-end Angular development. It is expected that this
-- language spec be used in concert with the typescript spec, which loads typescript-tools.nvim
require("lsp"):add_spec({
	name = "angular",
	ft = { "typescript", "htmlangular" },

	formatters = { "prettierd" },
	mason_auto_install = { "angular-language-server" },

	plugins = { { "joeveiga/ng.nvim" } },

	on_load = function()
		---- Register custom on_attach behaviour for Angular as the language server
		---- exposes some specific keybindings we'd like to use. We still want the
		---- standard 'common' on_attach though.
		require("lsp"):set_handler(
			"angularls",
			---@param bufnr number
			function(_, bufnr)
				require("which-key").add({
					{ "<leader>a", buffer = bufnr, group = "Angular" },
					{
						"<leader>aT",
						"<CMD>lua require('ng').get_template_tcb()<CR>",
						buffer = bufnr,
						desc = "Get template TCB",
					},
					{
						"<leader>ac",
						"<CMD>lua require('ng').goto_component_with_template_file()<CR>",
						buffer = bufnr,
						desc = "Go to component templ file",
					},
					{
						"<leader>at",
						"<CMD>lua require('ng').goto_template_for_component()<CR>",
						buffer = bufnr,
						desc = "Go to Template",
					},
				})

				vim.bo[bufnr].shiftwidth = 2
				vim.bo[bufnr].tabstop = 2

				return { auto_hover = false, whichkey_binding = true }
			end
		)

		local angularls_path = vim.fn.expand("$MASON/packages/angular-language-server")
		local cmd = {
			"ngserver",
			"--stdio",
			"--tsProbeLocations",
			table.concat({
				angularls_path,
				vim.uv.cwd(),
			}, ","),
			"--ngProbeLocations",
			table.concat({
				angularls_path .. "/node_modules/@angular/language-server",
				vim.uv.cwd(),
			}, ","),
		}

		vim.lsp.config("angularls", {
			cmd = cmd,
			on_new_config = function(new_config, _)
				new_config.cmd = cmd
			end,
			root_markers = { "angular.json" },
		})
	end,
})
