-- WARN this is fragile, monkey-patchy code which is designed to de-duplicate
-- results from multiple LSPs.
-- If trouble breaks after an update, consider this your first suspect.

local trbl = require("trouble.sources.lsp")

---@param method string
---@param cb trouble.Source.Callback
---@param context? any lsp params context
---@diagnostic disable-next-line: duplicate-set-field
trbl.get_locations = function(method, cb, context)
    local win = vim.api.nvim_get_current_win()
    ---@type lsp.TextDocumentPositionParams
    local params = vim.lsp.util.make_position_params(win)
    ---@diagnostic disable-next-line: inject-field
    params.context = context

    trbl.request(method, params,
        function(results)
            ---@type trouble.Item[]
            local items, seen, deduped = {}, {}, {}
            local clients, numClients = {}, 0
            for client, result in pairs(results) do
                if clients[client.id] == nil then
                    numClients = numClients + 1
                    clients[client.id] = true
                end

                vim.list_extend(items, trbl.get_items(client, result))
            end

            if numClients <= 1 then
                vim.notify(
                    "DEDUPE: Only '" .. numClients .. "' responded with locations; no need to deduplicate",
                    vim.log.levels.TRACE
                )

                cb(items)
                return
            end

            for _, item in pairs(items) do
                local key = item.filename .. ":" .. item.pos[1] .. ":" .. item.pos[2]
                if seen[key] ~= true then
                    table.insert(deduped, item)
                    seen[key] = true
                end
            end

            vim.notify(
                "DEDUPE: Out of " .. tostring(#items) .. " location results, " .. tostring(#deduped) .. " were kept",
                vim.log.levels.TRACE
            )
            cb(deduped)
        end)
end
