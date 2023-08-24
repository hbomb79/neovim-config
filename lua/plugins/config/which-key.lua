local whichkey = require("which-key")

whichkey.setup {
    plugins = {
        marks = true,     -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
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
    ["<S-x>"] = { "<cmd>bdelete<CR>", "" },
    K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP Hover" },
    g = {
        name = "+LSP",
        d = { "<cmd>lua vim.lsp.buf.definition()<CR>zz<CR>", "Jump to Definition" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<CR>zz<CR>", "Jump to Declaration" },
        r = { "<cmd>lua vim.lsp.buf.references()<CR>", "List References" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<CR>zz<CR>", "Jump to Implementation" }
    },
    H = {
        name = "Hop",
        h = { "<cmd>lua require('hop').hint_words()<CR>", "Global Word" },
        H = { "<cmd>lua require('hop').hint_words { current_line_only = true }<CR>", "Line Word" },
        c = { "<cmd>lua require('hop').hint_char1({ current_line_only = false })<CR>", "Global Char" },
        C = { "<cmd>lua require('hop').hint_char1({ current_line_only = true })<CR>", "Line Char" }
    }
})

-- Configure <leader> keymaps (default leader is space)
whichkey.register({
    ["<leader>"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    ["/"] = { "<cmd>Commentary<CR>", "Comment" },
    ["c"] = { "<cmd>bd<CR>", "Close Buffer" },
    ["e"] = { "<cmd>Neotree<CR>", "Open File Tree" },
    ["E"] = { "<cmd>Neotree reveal<CR>", "Reveal file in Tree" },
    ["f"] = { "<cmd>Telescope find_files<CR>", "Find File" },
    [";"] = { "<cmd>Dashboard<CR>", "Open Dashboard" },
    d = {
        name = "+Diagnostics",
        t = { "<cmd>TroubleToggle<CR>", "Trouble Toggle" },
        w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", "Workspace" },
        d = { "<cmd>TroubleToggle lsp_document_diagnostics<CR>", "Document" },
        q = { "<cmd>TroubleToggle quickfix<CR>", "Quickfix" },
        l = { "<cmd>TroubleToggle loclist<CR>", "Loclist" },
        r = { "<cmd>TroubleToggle lsp_references<CR>", "References" },
    },
    D = {
        name = "+Debug",
        b = { "<cmd>DebugToggleBreakpoint<CR>", "Toggle Breakpoint" },
        c = { "<cmd>DebugContinue<CR>", "Continue" },
        i = { "<cmd>DebugStepInto<CR>", "Step Into" },
        o = { "<cmd>DebugStepOver<CR>", "Step Over" },
        r = { "<cmd>DebugToggleRepl<CR>", "Toggle Repl" },
        s = { "<cmd>DebugStart<CR>", "Start" }
    },
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
    -- l = {
    --     name = "+LSP",
    --     a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
    --     A = { "<cmd>Lspsaga range_code_action<CR>", "Selected Action" },
    --     d = { "<cmd>Telescope lsp_document_diagnostics<CR>", "Document Diagnostics" },
    --     D = { "<cmd>Telescope lsp_workspace_diagnostics<CR>", "Workspace Diagnostics" },
    --     f = { "<cmd>LspFormatting<CR>", "Format" },
    --     i = { "<cmd>LspInfo<CR>", "Info" },
    --     l = { "<cmd>Lspsaga lsp_finder<CR>", "LSP Finder" },
    --     L = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics" },
    --     p = { "<cmd>Lspsaga preview_definition<CR>", "Preview Definition" },
    --     q = { "<cmd>Telescope quickfix<CR>", "Quickfix" },
    --     r = { "<cmd>Lspsaga rename<CR>", "Rename" },
    --     t = { "<cmd>LspTypeDefinition<CR>", "Type Definition" },
    --     x = { "<cmd>cclose<CR>", "Close Quickfix" },
    --     s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
    --     S = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Workspace Symbols" }
    -- },
    s = {
        name = "+Search",
        b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
        d = { "<cmd>Telescope lsp_document_diagnostics<CR>", "Document Diagnostics" },
        D = { "<cmd>Telescope lsp_workspace_diagnostics<CR>", "Workspace Diagnostics" },
        f = { "<cmd>Telescope find_files<CR>", "Find File" },
        m = { "<cmd>Telescope marks<CR>", "Marks" },
        M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
        R = { "<cmd>Telescope registers<CR>", "Registers" },
        t = { "<cmd>Telescope live_grep<CR>", "Text" }
    },
    p = {
        name = "harpoon",
        a = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "add file" },
        r = { "<cmd>lua require('harpoon.mark').rm_file()<CR>", "remove file" },
        m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "harpoon menu" },
        n = { "<cmd>lua require('harpoon.ui').nav_next()<CR>", "next file" },
        p = { "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "previous file" },
        ["1"] = { "<cmd> lua require('harpoon.ui').nav_file(1)<CR>", "file 1" },
        ["2"] = { "<cmd> lua require('harpoon.ui').nav_file(2)<CR>", "file 2" },
        ["3"] = { "<cmd> lua require('harpoon.ui').nav_file(3)<CR>", "file 3" },
    },
    H = {
        name = "help/debug/conceal",
        c = {
            name = "conceal",
            h = { ":set conceallevel=1<CR>", "hide/conceal" },
            s = { ":set conceallevel=0<CR>", "show/unconceal" },
        },
        t = {
            name = "treesitter",
            t = { vim.treesitter.inspect_tree, "show tree" },
            c = { ":=vim.treesitter.get_captures_at_cursor()<CR>", "show capture" },
            n = { ":=vim.treesitter.get_node():type()<CR>", "show node" },
        },
    }
}, { prefix = "<leader>" })
