return {
    "tpope/vim-sensible",
    {
        "rcarriga/nvim-notify",
        lazy = true
    },
    {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        opts = {},
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
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
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local opts = require("plugins.config.feline")
            require("feline").setup(opts)
        end
    },
    {
        "folke/which-key.nvim",
        config = function()
            require("plugins.config.which-key")
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = { close_if_last_window = true },
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
    }
}
