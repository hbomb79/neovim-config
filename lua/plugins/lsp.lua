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
        }
    },
    {
        'mrded/nvim-lsp-notify',
        config = function()
            require('lsp-notify').setup({
                notify = require('notify'),
            })
        end,
        dependencies = { 'nvim-notify' },
    }
}
