require("lsp"):add_spec({
	ft = { "typescript", "javascript" },

	formatters = { "prettierd" },

	plugins = {
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			config = function()
				require("typescript-tools").setup({
					root_markets = { "package.json" },
					root_dir = nil,
				})
			end,
		},
	},

	on_load = function()
		local prettier_found = #(vim.fs.find(".prettierrc.json", { upward = true, stop = vim.uv.os_homedir() })) ~= 0

		require("lsp"):set_handler(
			"typescript-tools",
			---@param client vim.lsp.Client
			---@param bufnr integer
			function(client, bufnr)
				-- Disable typescript provided formatting capabilities when prettier configuration is found
				-- so the two don't fight each other.
				if prettier_found then
					vim.notify(
						"Disabling 'documentFormattingProvider', 'documentRangeFormattingProvider' for typescript-tools: 'prettierrc' found in root",
						vim.log.levels.DEBUG
					)

					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				local angular_connected = false
				for _, cl in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
					if cl.name == "angularls" then
						angular_connected = true
						break
					end
				end

				if angular_connected then
					-- If this buffer has an angular-language-server attached already, then
					-- disable these capabilities to prevent the two LSPs fighting each other.
					vim.notify(
						"Disabling 'referencesProvider', 'renameProvider' for typescript-tools: 'angularls' is attached to same buffer",
						vim.log.levels.DEBUG
					)
					client.server_capabilities.referencesProvider = false
					client.server_capabilities.renameProvider = false
				end

				return {}
			end
		)
	end,
})
