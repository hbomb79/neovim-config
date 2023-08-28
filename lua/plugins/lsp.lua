return {
    {
        'williamboman/mason.nvim',
        config = true,
    },
    { "neovim/nvim-lspconfig" },
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
        }
    }
}
