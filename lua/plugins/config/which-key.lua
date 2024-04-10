local whichkey = require("which-key")
local USE_TROUBLE_FOR_LSP_BINDINGS = true

-- Default options are fine
whichkey.setup {}

-- Set leader
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

-- Comments in visual mode
vim.api.nvim_set_keymap("v", "<leader>/", ":Commentary<CR>", { noremap = true, silent = true })

-- Sends LSP list response to QF list, and then
-- opens that list with trouble.nvim and closes the QF list.
local function lsp_on_list(options)
    vim.fn.setqflist({}, ' ', options)

    if USE_TROUBLE_FOR_LSP_BINDINGS then
        require("trouble").open("quickfix")
        vim.cmd("cclose")
    end
end

-- Configure <leader>-less, normal-mode keymaps
whichkey.register({
    ["<S-x>"] = { "<cmd>bdelete<CR>", "" },
    K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP Hover" },
    g = {
        name = "+LSP",
        r = { function() vim.lsp.buf.references(nil, { on_list = lsp_on_list }) end, "List References" },
        i = { function() vim.lsp.buf.implementation { on_list = lsp_on_list } end, "Show Implementations" },
        d = { function() vim.lsp.buf.definition { on_list = lsp_on_list } end, "Jump to Definition" },
        D = { function() vim.lsp.buf.declaration { on_list = lsp_on_list } end, "Jump to Declaration" },
    },
    H = {
        name = "+Hop",
        h = { "<cmd>lua require('hop').hint_words()<CR>", "Global Word" },
        H = { "<cmd>lua require('hop').hint_words {current_line_only = true}<CR>", "Line Word" },
        c = { "<cmd>lua require('hop').hint_char1 {current_line_only = false}<CR>", "Global Char" },
        C = { "<cmd>lua require('hop').hint_char1 {current_line_only = true}<CR>", "Line Char" }
    }
})

-- Configure <leader> keymaps (default leader is space) in normal-mode
-- Specific keymaps for LSPs/languages may be set elsewhere (typically
-- in an LSPs onattach (see lsp/init.lua)
whichkey.register({
    ["<leader>"] = { "<cmd>nohlsearch<CR>", "Clear Search Highlight" },
    ["/"] = { "<cmd>Commentary<CR>", "Toggle Line Comment" },
    ["e"] = { "<cmd>Neotree<CR>", "Open File Tree" },
    ["E"] = { "<cmd>Neotree reveal<CR>", "Reveal file in Tree" },
    ["f"] = { "<cmd>Telescope find_files<CR>", "Find File" },
    [";"] = { "<cmd>Dashboard<CR>", "Open Dashboard" },
    g = {
        name = "+Git",
        j = { "<cmd>NextHunk<CR>", "Next Hunk" },
        k = { "<cmd>PrevHunk<CR>", "Prev Hunk" },
        p = { "<cmd>PreviewHunk<CR>", "Preview Hunk" },
        r = { "<cmd>ResetHunk<CR>", "Reset Hunk" },
        R = { "<cmd>ResetBuffer<CR>", "Reset Buffer" },
        s = { "<cmd>StageHunk<CR>", "Stage Hunk" },
        u = { "<cmd>UndoStageHunk<CR>", "Undo Stage Hunk" },
        o = { "<cmd>Telescope git_status<CR>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<CR>", "Checkout commit" },
        C = { "<cmd>Telescope git_bcommits<CR>", "Checkout commit(for current file)" },
    },
    t = {
        name = "+Diagnostics",
        t = { "<cmd>lua require('trouble').open()<CR>", "Open" },
        w = { "<cmd>lua require('trouble').open('workspace_diagnostics')<CR>", "Workspace" },
        d = { "<cmd>lua require('trouble').open('document_diagnostics')<CR>", "Document" },
        q = { "<cmd>lua require('trouble').open('quickfix')<CR><cmd>cclose<CR>", "Quickfix" },
        l = { "<cmd>lua require('trouble').open('loclist')<CR>", "Loclist" },
        r = { "<cmd>lua require('trouble').open('lsp_references')<CR>", "References" },
        n = { "<cmd>lua require('trouble').next {}<CR>", "Next" },
        p = { "<cmd>lua require('trouble').previous {}<CR>", "Previous" },
        x = { "<cmd>lua require('trouble').close()<CR>", "Close" },
    },
    p = {
        name = "+Harpoon",
        a = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add file" },
        r = { "<cmd>lua require('harpoon.mark').rm_file()<CR>", "Remove file" },
        m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" },
        n = { "<cmd>lua require('harpoon.ui').nav_next()<CR>", "Next" },
        p = { "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "Previous" },
        ["1"] = { "<cmd> lua require('harpoon.ui').nav_file(1)<CR>", "File 1" },
        ["2"] = { "<cmd> lua require('harpoon.ui').nav_file(2)<CR>", "File 2" },
        ["3"] = { "<cmd> lua require('harpoon.ui').nav_file(3)<CR>", "File 3" },
    },
    s = {
        name = "+Search",
        c = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
        d = { "<cmd>Telescope lsp_document_diagnostics<CR>", "Document Diagnostics" },
        D = { "<cmd>Telescope lsp_workspace_diagnostics<CR>", "Workspace Diagnostics" },
        f = { "<cmd>Telescope find_files<CR>", "Find File" },
        m = { "<cmd>Telescope marks<CR>", "Marks" },
        M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
        h = { "<cmd>Telescope help_tags<CR>", "Help Tag" },
        r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
        R = { "<cmd>Telescope registers<CR>", "Registers" },
        t = { "<cmd>Telescope live_grep<CR>", "Text" }
    },
    -- TODO actually setup debugging, probably only for DAP <-> Metals
    -- D = {
    --     name = "+Debug",
    --     b = { "<cmd>DebugToggleBreakpoint<CR>", "Toggle Breakpoint" },
    --     c = { "<cmd>DebugContinue<CR>", "Continue" },
    --     i = { "<cmd>DebugStepInto<CR>", "Step Into" },
    --     o = { "<cmd>DebugStepOver<CR>", "Step Over" },
    --     r = { "<cmd>DebugToggleRepl<CR>", "Toggle Repl" },
    --     s = { "<cmd>DebugStart<CR>", "Start" }
    -- },
}, { prefix = "<leader>" })
