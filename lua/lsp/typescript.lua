local prettier_found = #(
    vim.fs.find(".prettierrc.json", {
        upward = true,
        stop = vim.loop.os_homedir()
    })
) ~= 0

require "lsp":set_handler("typescript-tools",
    ---@param client lsp.Client
    function(client, _)
        if prettier_found then
            vim.notify(
                "Disabling 'documentFormattingProvider', 'documentRangeFormattingProvider' for typescript-tools: 'prettierrc' found in root",
                vim.log.levels.DEBUG
            )

            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end

        return { auto_format = false }
    end
)

require "lsp":notify_new_lsp()
