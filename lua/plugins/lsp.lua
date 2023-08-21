return {
    "tami5/lspsaga.nvim",
    {
        'williamboman/mason.nvim',
        opts = {},
    },
    { "neovim/nvim-lspconfig" },
    {
        'hrsh7th/nvim-cmp',
        config = function() require("plugins.config.nvim-cmp") end,
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
            -- options
        },
    }
}
