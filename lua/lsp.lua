local M = {
	initialised = false,

	---@alias LspHandler fun(client: vim.lsp.Client, buffer: number): AttachOptions?
	---@type { [string]: LspHandler }
	handlers = {},
}

-- Initialises the plugin manager by creating an autocmd on the
-- LspAttach event, and configuring the global LSP settings/handlers.
function M:initialise()
	if self.initialised then
		return
	end
	self.initialised = true

	-- Remove default LSP mappings that conflict with our own
	vim.keymap.del("n", "gri")
	vim.keymap.del("n", "gO")

	local grp = vim.api.nvim_create_augroup("UserLspConfig", {})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = grp,
		callback = function(tbl)
			self:buffer_attach(tbl.buf)
		end,
	})

	vim.fn.sign_define(
		"LspDiagnosticsSignError",
		{ texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError" }
	)
	vim.fn.sign_define(
		"LspDiagnosticsSignWarning",
		{ texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning" }
	)
	vim.fn.sign_define(
		"LspDiagnosticsSignHint",
		{ texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint" }
	)
	vim.fn.sign_define(
		"LspDiagnosticsSignInformation",
		{ texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation" }
	)

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			prefix = "",
			spacing = 0,
		},
		signs = true,
		underline = true,
	})

	-- symbols for autocomplete
	vim.lsp.protocol.CompletionItemKind = {
		"   (Text) ",
		"   (Method)",
		"   (Function)",
		"   (Constructor)",
		" ﴲ  (Field)",
		"[] (Variable)",
		"   (Class)",
		" ﰮ  (Interface)",
		"   (Module)",
		" 襁 (Property)",
		"   (Unit)",
		"   (Value)",
		" 練 (Enum)",
		"   (Keyword)",
		"   (Snippet)",
		"   (Color)",
		"   (File)",
		"   (Reference)",
		"   (Folder)",
		"   (EnumMember)",
		" ﲀ  (Constant)",
		" ﳤ  (Struct)",
		"   (Event)",
		"   (Operator)",
		"   (TypeParameter)",
	}
end

-- Handles an 'LspAttach' event by execting the common on_attach, and any
-- language-server specific handlers (which must have been registered before-hand).
function M:buffer_attach(buffer)
	local clients = vim.lsp.get_clients({ bufnr = buffer })
	for _, client in pairs(clients) do
		local attachOptions = nil
		local typeHandler = self.handlers[client.name]
		if type(typeHandler) == "function" then
			local o = typeHandler(client, buffer)
			attachOptions = o
		end

		self:common_on_attach(buffer, client, attachOptions)
	end
end

-- Returns the value for the key provided from the table. If no value
-- found, the default value is returned instead.
---@param options table
---@param key string
---@param default boolean
---@return boolean
local function getOptionValue(options, key, default)
	local v = options[key]
	if type(v) == "nil" then
		return default
	end

	return v
end

-- Common 'on_attach' behaviour which should be applied to a buffer
-- anytime a buffer attaches to a language server.
-- It should be expected that this code could be run multiple times for the
-- same buffer, and so the code in here should be aware of that.
---@class AttachOptions
---@field auto_hover boolean?
---@field whichkey_binding boolean?
---@param opts AttachOptions?
function M:common_on_attach(buffer, client, opts)
	vim.notify(
		"Client '" .. client.name .. "' (buffer " .. vim.inspect(buffer) .. ") attached with opts " .. vim.inspect(opts),
		vim.log.levels.TRACE
	)

	opts = opts or { auto_hover = true, whichkey_binding = true }
	if getOptionValue(opts, "auto_hover", true) then
		-- Clear any hover-effects when the cusor moves
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = buffer,
			callback = vim.lsp.buf.clear_references,
		})

		-- Highlight matching terms under the cusor on 'hover'
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = buffer,
			callback = vim.lsp.buf.document_highlight,
		})
	end

	if getOptionValue(opts, "whichkey_binding", true) then
		require("which-key").add({
			{ "<leader>l", buffer = buffer, group = "LSP" },
			{ "<leader>lA", "<cmd>lua vim.lsp.codelens.run()<CR>", buffer = buffer, desc = "Code Lens" },
			{ "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", buffer = buffer, desc = "Workspace Symbols" },
			{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", buffer = buffer, desc = "Code Action" },
			{ "<leader>ld", "<cmd>Telescope diagnostics<CR>", buffer = buffer, desc = "Document Diagnostics" },
			{ "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", buffer = buffer, desc = "Format" },
			{ "<leader>li", "<cmd>LspInfo<CR>", buffer = buffer, desc = "Info" },
			{ "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<CR>", buffer = buffer, desc = "Line Diagnostics" },
			{ "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<CR>", buffer = buffer, desc = "Next Error" },
			{ "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", buffer = buffer, desc = "Prev Error" },
			{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", buffer = buffer, desc = "Rename" },
			{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", buffer = buffer, desc = "Document Symbols" },
		})

		require("which-key").add({
			{ "g", buffer = buffer, group = "LSP" },
			{
				"gD",
				function()
					vim.lsp.buf.declaration()
					-- require("trouble").open("lsp_declarations")
				end,
				buffer = buffer,
				desc = "Declarations",
			},
			{
				"gT",
				function()
					vim.lsp.buf.type_definition()
					-- require("trouble").open("lsp_type_definitions")
				end,
				buffer = buffer,
				desc = "Type Definitions",
			},
			{
				"gd",
				function()
					vim.lsp.buf.definition()
					-- require("trouble").open("lsp_definitions")
				end,
				buffer = buffer,
				desc = "Definitions",
			},
			{
				"gi",
				function()
					vim.lsp.buf.implementation()
					-- require("trouble").open("lsp_implementations")
				end,
				buffer = buffer,
				desc = "Implementations",
			},
			{
				"gr",
				function()
					vim.lsp.buf.references()
					-- require("trouble").open("lsp_references")
				end,
				buffer = buffer,
				desc = "References",
			},
		})
	end
end

---@param handler LspHandler
function M:set_handler(lspName, handler)
	if type(handler) ~= "function" then
		error("Cannot set handler for LSP '" .. lspName .. "', expected function, received " .. type(handler))
	end

	if self.handlers[lspName] ~= nil then
		error("Cannot set handler for LSP '" .. lspName .. "' as a handler for this LSP is already set")
	end

	vim.notify("Registered '" .. lspName .. "' LSP handler", vim.log.levels.DEBUG)
	self.handlers[lspName] = handler
end

-- There is a bug for when an LSP is lazy-loaded
-- due to filetype plugin triggering the LSP config after the buffer
-- has been loaded. This snippet can be called _after_ setup of the LSP
-- to trigger the 'FileType' event on all the buffers; this will encourage
-- any new LSPs to attach.
function M:notify_new_lsp()
	vim.schedule(function()
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			local valid = vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
			if valid and vim.bo[bufnr].buftype == "" then
				local augroup_lspconfig = vim.api.nvim_create_augroup("lspconfig", { clear = false })
				vim.api.nvim_exec_autocmds("FileType", { group = augroup_lspconfig, buffer = bufnr })
			end
		end
	end)
end

return M
