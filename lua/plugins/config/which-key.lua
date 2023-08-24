local whichkey = require("which-key")

whichkey.setup {
    plugins = {
        marks = true,         -- shows a list of your marks on ' and `
        registers = true,     -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true,      -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true,      -- default bindings on <c-w>
            nav = true,          -- misc bindings to work with windows
            z = true,            -- bindings for folds, spelling and others prefixed with z
            g = true,            -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>',   -- binding to scroll up inside the popup
    },
    window = {
        border = "none",          -- none, single, double, shadow
        position = "bottom",      -- bottom, top
        margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0
    },
    layout = {
        height = { min = 4, max = 25 },                                           -- min and max height of the columns
        width = { min = 20, max = 50 },                                           -- min and max width of the columns
        spacing = 3,                                                              -- spacing between columns
        align = "left",                                                           -- align columns left, center or right
    },
    ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true,                                                             -- show help message on the command line when the popup is visible
    triggers = "auto",                                                            -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}


-- Set leader
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

-- Comments in visual mode
vim.api.nvim_set_keymap("v", "<leader>/", ":Commentary<CR>", { noremap = true, silent = true })

-- Configure <leader>-less keymaps
whichkey.register({
    ["<S-x>"] = { "<cmd>bdelete<cr>", "" },
    K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP Hover" },
    g = {
        name = "+LSP",
        d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Jump to Definition" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Jump to Declaration" },
        r = { "<cmd>lua vim.lsp.buf.references()<CR>", "List References" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Jump to Implementation" }
    },
    H = {
        name = "Hop",
        h = {
            function() require("hop").hint_words() end,
            "Global Word"
        },
        H = {
            function() require("hop").hint_words { current_line_only = true } end,
            "Line Word"
        },
        c = {
            function() require("hop").hint_char1({ current_line_only = false }) end,
            "Global Char"
        },
        C = {
            function() require("hop").hint_char1({ current_line_only = true }) end,
            "Line Char"
        }
    }
})

-- Configure <leader> keymaps (default leader is space)
whichkey.register({
    ["<leader>"] = { "<cmd>nohlsearch<cr>", "No Highlight" },
    ["/"] = { "<cmd>Commentary<cr>", "Comment" },
    ["c"] = { "<cmd>bd<cr>", "Close Buffer" },
    ["e"] = { "<cmd>Neotree<cr>", "Open File Tree" },
    ["E"] = { "<cmd>Neotree reveal<cr>", "Reveal file in Tree" },
    ["f"] = { "<cmd>Telescope find_files<cr>", "Find File" },
    [";"] = { "<cmd>Dashboard<cr>", "Open Dashboard" },
    d = {
        name = "+Diagnostics",
        t = { "<cmd>TroubleToggle<cr>", "Trouble Toggle" },
        w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "Workspace" },
        d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Document" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
        l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
        r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
    },
    D = {
        name = "+Debug",
        b = { "<cmd>DebugToggleBreakpoint<cr>", "Toggle Breakpoint" },
        c = { "<cmd>DebugContinue<cr>", "Continue" },
        i = { "<cmd>DebugStepInto<cr>", "Step Into" },
        o = { "<cmd>DebugStepOver<cr>", "Step Over" },
        r = { "<cmd>DebugToggleRepl<cr>", "Toggle Repl" },
        s = { "<cmd>DebugStart<cr>", "Start" }
    },
    g = {
        name = "+Git",
        j = { "<cmd>NextHunk<cr>", "Next Hunk" },
        k = { "<cmd>PrevHunk<cr>", "Prev Hunk" },
        p = { "<cmd>PreviewHunk<cr>", "Preview Hunk" },
        r = { "<cmd>ResetHunk<cr>", "Reset Hunk" },
        R = { "<cmd>ResetBuffer<cr>", "Reset Buffer" },
        s = { "<cmd>StageHunk<cr>", "Stage Hunk" },
        u = { "<cmd>UndoStageHunk<cr>", "Undo Stage Hunk" },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)" },
    },
    l = {
        name = "+LSP",
        a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
        A = { "<cmd>Lspsaga range_code_action<cr>", "Selected Action" },
        d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
        D = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
        f = { "<cmd>LspFormatting<cr>", "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        l = { "<cmd>Lspsaga lsp_finder<cr>", "LSP Finder" },
        L = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics" },
        p = { "<cmd>Lspsaga preview_definition<cr>", "Preview Definition" },
        q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
        r = { "<cmd>Lspsaga rename<cr>", "Rename" },
        t = { "<cmd>LspTypeDefinition<cr>", "Type Definition" },
        x = { "<cmd>cclose<cr>", "Close Quickfix" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" }
    },
    s = {
        name = "+Search",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
        D = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        m = { "<cmd>Telescope marks<cr>", "Marks" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        t = { "<cmd>Telescope live_grep<cr>", "Text" }
    },
    S = {
        name = "+Session",
        s = { "<cmd>SessionSave<cr>", "Save Session" },
        l = { "<cmd>SessionLoad<cr>", "Load Session" }
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
