-- Register Scala language tools. Some fairly extensive bootstrapping occurs
-- in the post load hook, mainly to fix a bug which broke diagnostics.

require("langs"):add_spec({
	ft = { "scala", "sbt" },

	plugins = {
		{
			"scalameta/nvim-metals",
			opts = function()
				local metals_config = require("metals").bare_config()
				metals_config.settings = {
					showImplicitArguments = true,
					excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
				}
				metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

				-- Capture the metals custom status messages, and redirect
				-- them to the standard $/progress handler so that other plugins
				-- (e.g. fidget) can capture and display them
				-- https://github.com/scalameta/nvim-metals/discussions/479
				metals_config.init_options.statusBarProvider = "on"
				metals_config.handlers["metals/status"] = function(err, status, ctx)
					local val = {}
					local text = status.text:gsub("[⠇⠋⠙⠸⠴⠦]", ""):gsub("^%s*(.-)%s*$", "%1")
					if status.hide then
						val = { kind = "end" }
					elseif status.show then
						val = { kind = "begin", title = text }
					elseif status.text then
						val = { kind = "report", message = text }
					else
						return
					end

					local msg = { token = "metals", value = val }
					vim.lsp.handlers["$/progress"](err, msg, ctx)
				end

				return metals_config
			end,
			config = function(_, opts)
				-- Autocmd that will actually be in charging of starting the whole thing
				local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "scala", "sbt" },
					callback = function()
						require("metals").initialize_or_attach(opts)
					end,
					group = nvim_metals_group,
				})
			end,
		},
	},

	on_load = function()
		-- Register custom metals LSP handler which will
		-- populate some special keybinds for metals-specific commands
		require("langs"):set_handler("metals", function(_, bufnr)
			require("which-key").add({
				{ "<leader>m", buffer = bufnr, group = "Scala Metals" },
				{
					"<leader>mc",
					"<CMD>lua require('telescope').extensions.metals.commands()<CR>",
					buffer = bufnr,
					desc = "Commands",
				},
				{
					"<leader>mh",
					"<CMD>lua require('metals').hover_worksheet({ border = 'single' })<CR>",
					buffer = bufnr,
					desc = "Hover worksheet",
				},
				{
					"<leader>mi",
					"<CMD>lua require('metals').toggle_setting('showImplicitArguments')<CR>",
					buffer = bufnr,
					desc = "Toggle implicit arguments",
				},
				{
					"<leader>mr",
					"<CMD>lua require('metals.tvp').reveal_in_tree()<CR>",
					buffer = bufnr,
					desc = "Reveal in tree",
				},
				{
					"<leader>mt",
					"<CMD>lua require('metals.tvp').toggle_tree_view()<CR>",
					buffer = bufnr,
					desc = "Toggle tree view",
				},
			})

			vim.api.nvim_buf_set_keymap(bufnr, "v", "K", "<cmd>lua require('metals').type_of_range()<CR>", {})
		end)
	end,

	neotest = {
		dependencies = {
			{ "stevanmilic/neotest-scala" },
		},
		adapter = function()
			return require("neotest-scala")({
				-- Command line arguments for runner
				-- Can also be a function to return dynamic values
				args = { "--no-color" },
				-- Runner to use. Will use bloop by default.
				-- Can be a function to return dynamic value.
				-- For backwards compatibility, it also tries to read the vim-test scala config.
				-- Possibly values bloop|sbt.
				runner = "sbt",
				-- Test framework to use. Will use utest by default.
				-- Can be a function to return dynamic value.
				-- Possibly values utest|munit|scalatest.
				framework = "scalatest",
			})
		end,
	},
})
