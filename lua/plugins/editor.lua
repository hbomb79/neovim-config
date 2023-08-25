return {
    "tpope/vim-sensible",
    {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = true,
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        "tpope/vim-commentary",
        cmd = "Commentary"
    },
    {
        "ThePrimeagen/harpoon",
        lazy = true
    },
    {
        "freddiehaddad/feline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function() return require("plugins.config.feline") end,
    },
    {
        "folke/which-key.nvim",
        config = function() require("plugins.config.which-key") end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            close_if_last_window = true,
            source_selector = {
                winbar = true
            }
        },
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree"
    },
    {
        "phaazon/hop.nvim",
        opts = { keys = 'etovxqpdygfblzhckisuran' },
        branch = "v2",
        lazy = true
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
        lazy = true
    }
}
