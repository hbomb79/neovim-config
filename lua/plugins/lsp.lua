return {
    {
        'williamboman/mason.nvim',
        config = true,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "lsp.yaml"
        end
    },
    {
        'hrsh7th/nvim-cmp',
        opts = function()
            return require("plugins.config.nvim-cmp")
        end,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lua'
        }
    },
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
            text = {
                spinner = "arc"
            }
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = { hint_enable = false }
    },
    -- {
    --     "folke/noice.nvim",
    --     opts = {}
    -- }
    {
        "mfussenegger/nvim-lint",
        config = function()
            require "plugins.config.nvim-lint"
        end,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "stevanmilic/neotest-scala"
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("neotest").setup({
                adapters = {
                    require("neotest-scala")({
                        -- Command line arguments for runner
                        -- Can also be a function to return dynamic values
                        args = { "--no-color" },
                        -- Runner to use. Will use bloop by default.
                        -- Can be a function to return dynamic value.
                        -- For backwards compatibility, it also tries to read the vim-test scala config.
                        -- Possibly values bloop|sbt.
                        runner = "sbt",
                        -- Test framework to use. Will use utest by default.
                        -- Can be a function to return dynamic value.
                        -- Possibly values utest|munit|scalatest.
                        framework = "scalatest",
                    })
                }
            })
        end
    }
}
