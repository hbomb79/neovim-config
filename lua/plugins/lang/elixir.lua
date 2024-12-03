return {
	"elixir-tools/elixir-tools.nvim",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local elixirls = require("elixir.elixirls")
		require("elixir").setup({
			-- nextls = {
			-- 	enable = true,
			-- 	init_options = {
			-- 		experimental = {
			-- 			completions = {
			-- 				enable = true, -- control if completions are enabled. defaults to false
			-- 			},
			-- 		},
			-- 	},
			-- 	on_attach = function(_, bufnr)
			-- 		vim.keymap.set("n", "<space>fp", ":Elixir nextls from-pipe<cr>", { buffer = bufnr, noremap = true })
			-- 		vim.keymap.set("n", "<space>tp", ":Elixir nextls to-pipe<cr>", { buffer = bufnr, noremap = true })
			-- 	end,
			-- },
			elixirls = {
				enable = true,
				settings = elixirls.settings({
					dialyzerEnabled = true,
					enableTestLenses = true,
					suggestSpecs = true,
				}),
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = bufnr, noremap = true })
					vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = bufnr, noremap = true })
					vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = bufnr, noremap = true })
				end,
			},
			projectionist = {
				enable = false,
			},
		})

		require("plugins.config.lsp.elixir")
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
