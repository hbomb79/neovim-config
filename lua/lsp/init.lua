local M = {
    initialised = false,
    handlers = {}
}


-- Initialises the plugin manager by creating an autocmd on the
-- LspAttach event, and configuring the global LSP settings/handlers.
function M:initialise()
    if self.initialised then
        return
    end
    self.initialised = true

    local grp = vim.api.nvim_create_augroup("UserLspConfig", {})
    vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        callback = function(tbl) self:buffer_attach(tbl.buf) end
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

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
                prefix = "",
                spacing = 0,
            },
            signs = true,
            underline = true,
        }
    )

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
        "   (TypeParameter)"
    }
end

-- Handles an 'LspAttach' event by execting the common on_attach, and any
-- language-server specific handlers (which must have been registered before-hand).
function M:buffer_attach(buffer)
    local clients = vim.lsp.get_active_clients { bufnr = buffer }
    for _, client in pairs(clients) do
        self:common_on_attach(buffer, client)

        local typeHandler = self.handlers[client.name]
        if type(typeHandler) == "function" then
            typeHandler(client, buffer)
        end
    end
end

-- Common 'on_attach' behaviour which should be applied to a buffer
-- anytime a buffer attaches to a language server.
-- It should be expected that this code could be run multiple times for the
-- same buffer, and so the code in here should be aware of that.
function M:common_on_attach(buffer, client)
    vim.notify("Client '" .. client.name .. "' (buffer " .. vim.inspect(buffer) .. ") attached", vim.log.levels.TRACE)

    -- Format on save using the connected LSP, if possible.
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buffer,
        callback = function() vim.lsp.buf.format() end,
    })

    -- Clear any hover-effects when the cusor moves
    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = buffer,
        callback = vim.lsp.buf.clear_references
    })

    -- Highlight matching terms under the cusor on 'hover'
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = buffer,
        callback = vim.lsp.buf.document_highlight
    })

    require("which-key").register({
        l = {
            name = "+LSP",
            a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
            d = { "<cmd>Telescope diagnostics<CR>", "Document Diagnostics" },
            s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
            S = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Workspace Symbols" },
            f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format" },
            i = { "<cmd>LspInfo<CR>", "Info" },
            r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
            n = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Error" },
            p = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev Error" },
            l = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Line Diagnostics" },
        }
    }, { prefix = "<leader>", buffer = buffer })
end

function M:set_handler(lspName, handler)
    if type(handler) ~= "function" then
        error("Cannot set handler for LSP '" .. lspName .. "', expected function, received " .. type(handler))
    end

    if self.handlers[lspName] ~= nil then
        error("Cannot set handler for LSP '" .. lspName .. "' as a handler for this LSP is already set")
    end

    self.handlers[lspName] = handler
end

return M
