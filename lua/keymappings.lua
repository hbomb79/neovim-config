-- Configure our Vim keybindings using Whichkey
local ok, whichkey = pcall(require, "which-key")
if not ok then
    print "[Warning] Whichkey plugin not found, cannot create keymappings. Ensure WhichKey installed (:PlugInstall)"
    return
end

-- Set leader
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', {noremap = true, silent = true})
vim.g.mapleader = ' '

-- Comments in visual mode
vim.api.nvim_set_keymap("v", "<leader>/", ":Commentary<CR>", {noremap = true, silent = true})

-- Configure <leader>-less keymaps
local hop = require('hop')
local directions = require('hop.hint').HintDirection
whichkey.register({
    ["<S-x>"] = {"<cmd>bdelete<cr>", ""},
    K = {"<cmd>lua vim.lsp.buf.hover()<CR>", "LSP Hover"},
    g = {
        name = "+LSP",
        d = {"<cmd>lua vim.lsp.buf.definition()<CR>", "Jump to Definition"},
        D = {"<cmd>lua vim.lsp.buf.declaration()<CR>", "Jump to Declaration"},
        r = {"<cmd>lua vim.lsp.buf.references()<CR>", "List References"},
        i = {"<cmd>lua vim.lsp.buf.implementation()<CR>", "Jump to Implementation"},
    },
    h = {
        name = "Hop",
        h = {
            function() hop.hint_words() end,
            "Global Word"
        },
        H = {
            function() hop.hint_words {current_line_only = true} end,
            "Line Word"
        },
        c = {
            function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false }) end,
            "Global Char"
        },
        C = {
            function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end,
            "Line Char"
        }
    }
})

-- Configure <leader> keymaps (default leader is space)
whichkey.register({
    ["<leader>"] = {"<cmd>nohlsearch<cr>", "No Highlight"},
    ["/"] = {"<cmd>Commentary<cr>", "Comment"},
    ["c"] = {"<cmd>bd<cr>", "Close Buffer"},
    ["e"] = {"<cmd>Neotree<cr>", "Open File Tree"},
    ["f"] = {"<cmd>Telescope find_files<cr>", "Find File"},
    [";"] = {"<cmd>Dashboard<cr>", "Open Dashboard"},
    d = {
        name = "+Diagnostics",
        t = {"<cmd>TroubleToggle<cr>", "Trouble Toggle"},
        w = {"<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "Workspace"},
        d = {"<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Document"},
        q = {"<cmd>TroubleToggle quickfix<cr>", "Quickfix"},
        l = {"<cmd>TroubleToggle loclist<cr>", "Loclist"},
        r = {"<cmd>TroubleToggle lsp_references<cr>", "References"},
    },
    D = {
        name = "+Debug",
        b = {"<cmd>DebugToggleBreakpoint<cr>", "Toggle Breakpoint"},
        c = {"<cmd>DebugContinue<cr>", "Continue"},
        i = {"<cmd>DebugStepInto<cr>", "Step Into"},
        o = {"<cmd>DebugStepOver<cr>", "Step Over"},
        r = {"<cmd>DebugToggleRepl<cr>", "Toggle Repl"},
        s = {"<cmd>DebugStart<cr>", "Start"}
    },
    g = {
        name = "+Git",
        j = {"<cmd>NextHunk<cr>", "Next Hunk"},
        k = {"<cmd>PrevHunk<cr>", "Prev Hunk"},
        p = {"<cmd>PreviewHunk<cr>", "Preview Hunk"},
        r = {"<cmd>ResetHunk<cr>", "Reset Hunk"},
        R = {"<cmd>ResetBuffer<cr>", "Reset Buffer"},
        s = {"<cmd>StageHunk<cr>", "Stage Hunk"},
        u = {"<cmd>UndoStageHunk<cr>", "Undo Stage Hunk"},
        o = {"<cmd>Telescope git_status<cr>", "Open changed file"},
        b = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
        c = {"<cmd>Telescope git_commits<cr>", "Checkout commit"},
        C = {"<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)"},
    },
    l = {
        name = "+LSP",
        a = {"<cmd>Lspsaga code_action<cr>", "Code Action"},
        A = {"<cmd>Lspsaga range_code_action<cr>", "Selected Action"},
        d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        f = {"<cmd>LspFormatting<cr>", "Format"},
        i = {"<cmd>LspInfo<cr>", "Info"},
        l = {"<cmd>Lspsaga lsp_finder<cr>", "LSP Finder"},
        L = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
        p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
        q = {"<cmd>Telescope quickfix<cr>", "Quickfix"},
        r = {"<cmd>Lspsaga rename<cr>", "Rename"},
        t = {"<cmd>LspTypeDefinition<cr>", "Type Definition"},
        x = {"<cmd>cclose<cr>", "Close Quickfix"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
        S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"}
    },
    s = {
        name = "+Search",
        b = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
        c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
        d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        f = {"<cmd>Telescope find_files<cr>", "Find File"},
        m = {"<cmd>Telescope marks<cr>", "Marks"},
        M = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
        r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
        R = {"<cmd>Telescope registers<cr>", "Registers"},
        t = {"<cmd>Telescope live_grep<cr>", "Text"}
    },
    S = {
        name = "+Session",
        s = {"<cmd>SessionSave<cr>", "Save Session"},
        l = {"<cmd>SessionLoad<cr>", "Load Session"}
    },
    p = {
        name = "harpoon",
        a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "add file" },
        r = { "<cmd>lua require('harpoon.mark').rm_file()<cr>", "remove file" },
        m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "harpoon menu" },
        n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "next file" },
        p = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "previous file" },
        ["1"] = { "<cmd> lua require('harpoon.ui').nav_file(1)<cr>", "file 1" },
        ["2"] = { "<cmd> lua require('harpoon.ui').nav_file(2)<cr>", "file 2" },
        ["3"] = { "<cmd> lua require('harpoon.ui').nav_file(3)<cr>", "file 3" },
    },
    H = {
        name = "help/debug/conceal",
        c = {
            name = "conceal",
            h = { ":set conceallevel=1<cr>", "hide/conceal" },
            s = { ":set conceallevel=0<cr>", "show/unconceal" },
        },
        t = {
            name = "treesitter",
            t = { vim.treesitter.inspect_tree, "show tree" },
            c = { ":=vim.treesitter.get_captures_at_cursor()<cr>", "show capture" },
            n = { ":=vim.treesitter.get_node():type()<cr>", "show node" },
        },
    }
}, { prefix = "<leader>" })
