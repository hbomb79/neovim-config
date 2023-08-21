return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "go", "scala", "lua", "javascript" },
                highlight = {
                    enable = true
                },
            }
        end,
        build = ":TSUpdate",
    },
    {
        "andymass/vim-matchup",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = "%"
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "html", "svelte", "astro" }
    },
    {
        'nvim-treesitter/playground',
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = "TSPlaygroundToggle"
    }
}
