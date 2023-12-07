local metals_config = require("metals").bare_config()

metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Capture the metals custom status messages, and redirect
-- them to the standard $/progress handler so that other plugins
-- (e.g. fidget) can capture and display them
-- https://github.com/scalameta/nvim-metals/discussions/479
metals_config.handlers['metals/status'] = function(err, status, ctx)
    local val = {}
    local text = status.text:gsub('[⠇⠋⠙⠸⠴⠦]', ''):gsub("^%s*(.-)%s*$", "%1")
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


-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt" },
    callback = function()
        require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
})

-- Register custom metals LSP handler which will
-- populate some special keybinds for metals-specific commands
require "lsp":set_handler('metals', function(_, buffer)
    require("which-key").register({
        name = "Scala Metals",
        ["h"] = { "<CMD>lua require('metals').hover_worksheet({ border = 'single' })<CR>", "Hover worksheet" },
        ["t"] = { "<CMD>lua require('metals.tvp').toggle_tree_view()<CR>", "Toggle tree view" },
        ["r"] = { "<CMD>lua require('metals.tvp').reveal_in_tree()<CR>", "Reveal in tree", },
        ["c"] = { "<CMD>lua require('telescope').extensions.metals.commands()<CR>", "Commands" },
        ["i"] = { "<CMD>lua require('metals').toggle_setting('showImplicitArguments')<CR>", "Toggle implicit arguments" },
    }, { prefix = "<leader>m", buffer = buffer })

    vim.api.nvim_buf_set_keymap(buffer, "v", "K", "<cmd>lua require('metals').type_of_range()<CR>", {})
end)
