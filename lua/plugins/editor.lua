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
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "catppuccin"
        },
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
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require "notify"
            vim.notify_once = require "notify"
        end
    },
    {
        "RRethy/vim-illuminate",
        config = function()
            require('illuminate').configure({
                providers = {
                    'lsp',
                    'treesitter',
                    'regex',
                },
                delay = 100,
                filetypes_denylist = {
                    'dirvish',
                    'fugitive',
                },
            })

            vim.api.nvim_set_hl(0, "IlluminatedWordText", {})
            vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
            vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
        end,
    }
}
