-- Centralized LSP management. Refer to root init.lua for configured languages.

local M = {
	initialised = false,

	---@class LangSpec {
	---@field name? string name of the language. If not specified, then the first filetype is used instead
	---@field ft string[] the filetypes to associate with this language
	---@field plugins? LazySpec[]|'AUTO' The Lazy.nvim plugin specs. Each will be set to lazy-load for the filetypes specified. If 'AUTO', then uses require('plugins.lang.<name>')
	---@field formatters? string[] Specify formatters to setup using Conform.
	---@field linters? string[] Specify linters to setup using nvim-lint.
	---@field post_load_hook? function|'AUTO' A function to call the first time a file is opened which matches this filetype. If 'AUTO', then uses require('lspconfig.<name>').
	---@field mason_auto_install? table The Mason LSP(s) to auto-install for this language.
	---}

	---@type LangSpec[]
	specs = {},

	---@alias LspHandler fun(client: vim.lsp.Client, buffer: number): AttachOptions?
	---@type { [string]: LspHandler }
	handlers = {},
}

---Adds a language specification to the LSP manager. Note that LSP installation is handled
---automatically by Mason, and this function is only responsible for registering the language
---@param specs LangSpec[]
function M:add_specs(specs)
	if self.initialised then
		error("cannot call add_specs() after called :initialise()")
	end

	for _, spec in pairs(specs) do
		if type(spec.ft) ~= "table" or #spec.ft == 0 then
			local err = string.format(
				"error adding spec: ft must be a non-empty table of filetypes, but found: %s for spec %s",
				vim.inspect(spec.ft),
				vim.inspect(spec)
			)
			error(err, 2)
		end

		if spec.name == nil then
			spec.name = spec.ft[1]
		end

		table.insert(self.specs, spec)
	end
end

---Iterates over all language specs and extracts the value of the given field (if any) and
---collates the values using the filetype of the language. For example, can be used to get all
---the linters grouped by the filetype they act on.
---
---@param field string
---@return { [string]: string[] }
function M:_group_lang_field_by_ft(field)
	---@type {[string]: string[]}
	local field_by_ft = {}

	for _, v in pairs(self.specs) do
		if v[field] == nil then
			goto continue
		end

		for _, ft in pairs(v.ft) do
			field_by_ft[ft] = field_by_ft[ft] or {}

			for _, val in pairs(v[field]) do
				table.insert(field_by_ft[ft], val)
			end
		end

		::continue::
	end

	return field_by_ft
end

---Uses the registered languages to construct linters for use with nvim-lint.
---@return { [string]: string[] }
function M:get_lang_linters()
	return self:_group_lang_field_by_ft("linters")
end

---Uses the registered languages to construct formatters_by_ft for use with Conform.
---@return { [string]: string[] }
function M:get_lang_formatters()
	return self:_group_lang_field_by_ft("formatters")
end

---Returns a table of LazySpecs to inject in to the Lazy plugin setup
---@return LazySpec[]
function M:get_lang_plugin_specs()
	local plugs = {}
	for _, spec in pairs(self.specs) do
		if spec.plugins == nil then
			goto continue
		end

		-- If 'AUTO' specified, then load the plugins from the derived (using
		-- the spec name) Lua module.
		local plugins = spec.plugins
		if type(spec.plugins) == "string" and spec.plugins == "AUTO" then
			plugins = require("plugins.lang." .. spec.name) ---@type LazySpec[]
		end

		if type(plugins) ~= "table" then
			local err = string.format(
				"Unable to process %q language spec: plugin spec invalid (expected table): %s",
				spec.name,
				vim.inspect(plugins)
			)
			error(err)
		end

		-- Iterate over the plugins specified. If any contain a 'filetype' Lazy-loading
		-- directive, raise an error to protect against an accidental programming error.
		for _, plug in pairs(plugins) do
			if plug.ft ~= nil then
				local err = string.format(
					"Unable to process %q language spec: plugin spec declared filetype: %s",
					spec.name,
					vim.inspect(spec)
				)
				error(err)
			end

			plug.ft = spec.ft
			table.insert(plugs, plug)
		end

		::continue::
	end

	return plugs
end

-- Initialises the plugin manager by creating an autocmd on the
-- LspAttach event, and configuring the global LSP settings/handlers.
function M:initialise()
	if self.initialised then
		return
	end
	self.initialised = true

	local raise = function(format, ...)
		local err = string.format(format, ...)
		error("failed to initialise LSP manager: " .. err, 3)
	end

	local name_set = {}
	for _, spec in pairs(self.specs) do
		if spec.name == nil then
			raise("language spec is missing name: %s", vim.inspect(spec))
		elseif name_set[spec.name] then
			raise("duplicate spec name %q. duplicate spec: %s", spec.name, vim.inspect(spec))
		end
		name_set[spec.name] = true

		local on_load = spec.post_load_hook
		if type(on_load) == "string" and on_load == "AUTO" then
			on_load = function()
				require("lspconfig." .. spec.name)
			end
		elseif type(on_load) ~= "function" and on_load ~= nil then
			raise("language spec %q specified invalid post_load_hook (type %s)", spec.name, type(spec.post_load_hook))
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = spec.ft,
			once = true,
			callback = function()
				-- If an auto_install LSP is specified, install it if not already
				if type(spec.mason_auto_install) == "table" then
					for _, lsp in pairs(spec.mason_auto_install) do
						if not require("mason-registry").is_installed(lsp) then
							vim.fn.execute("MasonInstall " .. lsp)
						end
					end
				end

				if type(on_load) == "function" then
					on_load()
				end
			end,
		})
	end

	-- Remove default LSP mappings that conflict with our own
	vim.keymap.del("n", "gri")
	vim.keymap.del("n", "grt")
	vim.keymap.del("n", "gO")
	pcall(vim.keymap.del, "n", "grr")
	pcall(vim.keymap.del, "n", "gra")
	pcall(vim.keymap.del, "n", "grn")

	vim.diagnostic.config({ virtual_text = true, severity_sort = true })

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

	vim.diagnostic.config({
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
			{
				"<leader>ld",
				"<cmd>Telescope diagnostics<CR>",
				buffer = buffer,
				desc = "Document Diagnostics",
			},
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

---Sets a function to run whenever the LSP specified attaches to a buffer. The
---callback is provided with the client and buffer, and can return modifiers which
---impact how the LSP behaves (e.g. disable auto_hover).
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
