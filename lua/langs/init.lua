---@class LanguageRegistry
local M = {
	---@type boolean
	---@private
	_did_setup = false,

	---@class LangSpec {
	---@field name? string name of the language. If not specified, then the first filetype is used instead
	---@field ft string[] the filetypes to associate with this language
	---@field plugins? zpack.Spec[] The plugin specs. Each will be set to lazy-load for the filetypes specified.
	---@field formatters? string[] Specify formatters to setup using Conform.
	---@field linters? string[] Specify linters to setup using nvim-lint.
	---@field on_load? fun() A function to call the FIRST time a file is opened which matches the languages filetype.
	---@field mason_auto_install? string[] The Mason LSP(s) to auto-install for this language. Note: formatters are auto-installed using mason-conform, so only LSPs/linters need to be specified here
	---@field ts_lang? string The Treesitter language to auto-start (or auto-install, if missing) when files matching the filetype(s) specified are opened
	---}

	---@type LangSpec[]
	specs = {},

	---@class AttachOptions
	---@field auto_hover boolean? Whether to trigger the 'document_highlight' LSP function when the cursor stops moving. Default to true
	---@field whichkey_binding boolean? Whether to create standard LSP keybindings for this buffer

	---@alias LspHandler fun(client: vim.lsp.Client, buffer: number): AttachOptions?
	---@type { [string]: LspHandler }
	handlers = {},
}

---@type vim.diagnostic.Opts
local default_diagnostics_config = {
	virtual_text = {
		prefix = "",
		spacing = 0,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
		},
	},
	underline = true,
	severity_sort = true,
}

--- Initialises the language registry. This includes (but isn't limited to):
---  * Processing and validating all registered languages
---  * Creating an autocmd for LSPAttach
---  * Configuring global LSP config (signs, diagnostic config)
function M:setup()
	if self._did_setup then
		return
	end

	self:_setup_langs()
	self._did_setup = true

	-- Remove default LSP mappings that conflict with our own
	for _, mapping in ipairs({ "gri", "grt", "gO", "grr", "gra", "grn", "grx" }) do
		vim.keymap.del("n", mapping)
	end

	local g = vim.api.nvim_create_augroup("UserLspConfig", {})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = g,
		callback = function(tbl)
			local bufnr = tbl.buf
			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			for _, client in pairs(clients) do
				local attachOptions = nil
				if type(self.handlers[client.name]) == "function" then
					attachOptions = self.handlers[client.name](client, bufnr)
				end

				self:common_on_attach(bufnr, client, attachOptions)
			end
		end,
	})

	vim.diagnostic.config(default_diagnostics_config)
end

--- Initialise language specifications by enumerating the files in the 'langs'
--- directory and loading them using 'require'.
---
--- This NeoVim configuration uses a centralized registry
--- to store language 'specifications'. These specifications contain the plugins,
--- linters, formatters, etc for each language, and act as a single place to keep all
--- configuration pertaining to a given language.
---
--- Each language specification exists within its own file in this directory; this method
--- is responsible for enumerating the files and loading them (via require).
---@private
function M:_setup_langs()
	local raise = function(format, ...)
		local err = string.format(format, ...)
		error("Failed to initialise language registry: " .. err, 4)
	end

	-- 1. Find the langs directory relative to the configuration root of this installation.
	local handle = vim.uv.fs_scandir(vim.fn.stdpath("config") .. "/lua/langs")
	if not handle then
		raise("langs directory missing")
	end

	-- 2. Iterate over every file in it, loading (via 'require') every .lua file
	while true do
		---@diagnostic disable-next-line: param-type-mismatch nil check performed above but LuaLS doesn't realise 'raise' will abort the function
		local name, type = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end

		if type == "file" and name:match("%.lua$") then
			require("langs." .. name:gsub("%.lua$", ""))
		end
	end

	-- 3. Validate specs
	local name_set = {}
	for _, spec in pairs(self.specs) do
		if spec.name == nil then
			raise("language spec is missing name: %s", vim.inspect(spec))
		elseif name_set[spec.name] then
			raise("duplicate spec name %q. duplicate spec: %s", spec.name, vim.inspect(spec))
		end
		name_set[spec.name] = true

		if type(spec.on_load) ~= "function" and spec.on_load ~= nil then
			raise("language spec %q specified invalid on_load callback (type %s)", spec.name, type(spec.on_load))
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = spec.ft,
			once = true,
			callback = function()
				self:mason_auto_install(spec)

				if type(spec.on_load) == "function" then
					spec.on_load()
				end
			end,
		})

		local language = spec.ts_lang or vim.treesitter.language.get_lang(spec.ft[1]) or spec.ft[1]
		vim.api.nvim_create_autocmd("FileType", {
			pattern = spec.ft,
			callback = function(ev)
				self:handle_treesitter_language(language, ev.buf)
			end,
		})
	end
end

--- Installs any lsps/formatters/etc specified by the language spec via Mason, if
--- they're not already installed.
---
---@param spec LangSpec
function M:mason_auto_install(spec)
	if type(spec.mason_auto_install) ~= "table" then
		return
	end

	for _, lsp in pairs(spec.mason_auto_install) do
		if not require("mason-registry").is_installed(lsp) then
			vim.fn.execute("MasonInstall " .. lsp)
		end
	end
end

--- Auto-installs the treesitter parser for the language provided (if not already installed),
--- and then enables/starts the parser for the buffer provided. Intended to be called
--- from an AutoCmd when a file is opened.
---
---@private
--- @param language string The language to install/enable
--- @param bufnr number The buffer to enable/start the parser for
function M:handle_treesitter_language(language, bufnr)
	local treesitter = require("nvim-treesitter")
	if not vim.list_contains(treesitter.get_installed(), language) then
		if vim.fn.executable("tree-sitter") ~= 1 then
			vim.notify(
				string.format(
					"Treesitter language for %q not found, but tree-sitter CLI not installed. Parsers cannot be installed.",
					language
				),
				vim.log.levels.ERROR
			)
			return
		end

		if not vim.list_contains(treesitter.get_available(), language) then
			vim.notify(
				string.format(
					"Treesitter lang %q not found and cannot be installed (not available via Treesitter)",
					language
				),
				vim.log.levels.WARN
			)
			return
		end

		treesitter.install(language):wait()
	end

	vim.treesitter.start(bufnr, language)
	vim.notify(
		string.format("Started treesitter highlighting for language %q on buffer %d", language, bufnr),
		vim.log.levels.DEBUG
	)
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
---
---@private
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
		self:set_buffer_keybinds(buffer)
	end
end

--- Adds LSP based keybindings (via which-key) scoped for the buffer provided. This is
--- typically called automatically when an LSP attaches. Benefit is that LSP-based bindings
--- are only set for buffers with an LSP attached.
---
---@private
function M:set_buffer_keybinds(bufnr)
	require("which-key").add({
		-- Standard 'Goto' bindings
		{ "g", buffer = bufnr, group = "LSP Goto" },
		{ "gD", vim.lsp.buf.declaration, buffer = bufnr, desc = "Declarations" },
		{ "gT", vim.lsp.buf.type_definition, buffer = bufnr, desc = "Type Definitions" },
		{ "gd", vim.lsp.buf.definition, buffer = bufnr, desc = "Definitions" },
		{ "gi", vim.lsp.buf.implementation, buffer = bufnr, desc = "Implementations" },
		{ "gr", vim.lsp.buf.references, buffer = bufnr, desc = "References" },

		-- LSP bindings
		{ "<leader>l", buffer = bufnr, group = "LSP" },
		{ "<leader>lA", "<cmd>lua vim.lsp.codelens.run()<CR>", buffer = bufnr, desc = "Code Lens" },
		{ "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", buffer = bufnr, desc = "Workspace Symbols" },
		{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", buffer = bufnr, desc = "Code Action" },
		{ "<leader>ld", "<cmd>Telescope diagnostics<CR>", buffer = bufnr, desc = "Document Diagnostics" },
		{ "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", buffer = bufnr, desc = "Format" },
		{ "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<CR>", buffer = bufnr, desc = "Line Diagnostics" },
		{ "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<CR>", buffer = bufnr, desc = "Next Error" },
		{ "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", buffer = bufnr, desc = "Prev Error" },
		{ "<leader>lr", "<cmd>lua require('renamer').rename({})<CR>", buffer = bufnr, desc = "Rename" },
		{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", buffer = bufnr, desc = "Document Symbols" },
		{
			"<leader>li",
			function()
				local enabled = vim.lsp.inlay_hint.is_enabled()
				vim.lsp.inlay_hint.enable(not enabled)
				vim.notify("Toggled LSP inlay hints " .. (not enabled and "on" or "off"))
			end,
			buffer = bufnr,
			desc = "Toggle inlay hints",
		},
		{
			"<leader>lL",
			function()
				-- Toggle between lines or just simple virtual text for LSP diagnostics by reading
				-- the current value and flipping it.
				-- Note that while this keybinding is scoped to this buffer, the diagnostic.config is global
				-- to the Neovim session.
				local lines_enabled = vim.diagnostic.config().virtual_lines
				vim.diagnostic.config({
					virtual_lines = not lines_enabled,
					virtual_text = (lines_enabled and default_diagnostics_config.virtual_text or false),
				})

				vim.notify("Toggled LSP virtual lines " .. (not lines_enabled and "on" or "off"))
			end,
			buffer = bufnr,
			desc = "Toggle virtual lines",
		},
		{
			"<leader>lD",
			function()
				local enabled = vim.diagnostic.is_enabled()
				vim.diagnostic.enable(not enabled, { bufnr = 0 })
				vim.notify("Toggled LSP diagnostics " .. (not enabled and "on" or "off"))
			end,
			buffer = bufnr,
			desc = "Toggle LSP",
		},
	})
end

--- Sets a function to run whenever the LSP specified attaches to a buffer. The
--- callback is provided with the client and buffer, and can return modifiers which
--- impact how the LSP behaves (e.g. disable auto_hover).
---
---@param handler LspHandler
function M:set_handler(lspName, handler)
	if type(handler) ~= "function" then
		error("Cannot set handler for LSP '" .. lspName .. "', expected function, received " .. type(handler))
	end

	if self.handlers[lspName] ~= nil then
		return vim.notify("Ignoring duplicate handler for '" .. lspName .. "'", vim.log.levels.WARN)
	end

	vim.notify("Registered '" .. lspName .. "' LSP handler", vim.log.levels.DEBUG)
	self.handlers[lspName] = handler
end

--- Adds a language specification to the registry.
---
---@param spec LangSpec
function M:add_spec(spec)
	if self._did_setup then
		error("cannot call :add_spec() after :initialise()")
	end

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

--- Uses the registered languages to construct linters for use with nvim-lint.
---
---@return { [string]: string[] }
function M:get_linters_by_ft()
	return self:_group_lang_field_by_ft("linters")
end

--- Uses the registered languages to construct formatters_by_ft for use with Conform.
---
---@return { [string]: string[] }
function M:get_formatters_by_ft()
	return self:_group_lang_field_by_ft("formatters")
end

--- Returns a table of LazySpecs to inject in to the Lazy plugin setup
---
---@return zpack.Spec[]
function M:get_plugin_specs()
	local plugs = {}
	for _, spec in pairs(self.specs) do
		if spec.plugins == nil then
			goto continue
		end

		if type(spec.plugins) ~= "table" then
			local err = string.format(
				"Unable to process %q language spec: plugin spec invalid (expected table): %s",
				spec.name,
				vim.inspect(spec.plugins)
			)
			error(err)
		end

		-- Iterate over the plugins specified. If any contain a 'filetype' Lazy-loading
		-- directive, raise an error to protect against an accidental programming error.
		for _, plug in pairs(spec.plugins) do
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

---Iterates over all language specs and extracts the value of the given field (if any) and
---collates the values using the filetype of the language. For example, can be used to get all
---the linters grouped by the filetype they act on.
---
---@private
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

return M
