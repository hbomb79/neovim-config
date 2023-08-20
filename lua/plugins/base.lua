-- Base Vim plugins that can be used for essentially
-- any environment (e.g. no LSP, autocompleters, etc)

local Plug = require "plugin-wrapper"

-- General
Plug "tpope/vim-sensible"
Plug "rafi/awesome-vim-colorschemes"
Plug "lewis6991/gitsigns.nvim"
Plug "f-person/git-blame.nvim"
Plug "tpope/vim-commentary"
Plug "nvim-tree/nvim-web-devicons"

Plug "ChristianChiarulli/dashboard-nvim"
Plug "folke/which-key.nvim"
Plug "rcarriga/nvim-notify"
Plug "freddiehaddad/feline.nvim"


-- Git integration
Plug "tpope/vim-fugitive"
Plug "tpope/vim-rhubarb"
Plug "airblade/vim-gitgutter"

-- Telescope stuff
Plug "nvim-lua/popup.nvim"
Plug "nvim-lua/plenary.nvim"
Plug "nvim-telescope/telescope.nvim"
Plug "nvim-telescope/telescope-fzy-native.nvim"
Plug "nvim-telescope/telescope-project.nvim"

-- File tree
Plug "MunifTanjim/nui.nvim"
Plug { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" }

-- HARPOOOON
Plug 'ThePrimeagen/harpoon'

-- Treesitter
Plug {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
Plug 'nvim-treesitter/playground'
Plug "windwp/nvim-ts-autotag"
Plug "andymass/vim-matchup"

-- Hop plugin
Plug {"phaazon/hop.nvim", branch = 'v2'}

-- Colorscheme
Plug {'catppuccin/nvim', config = function()
    vim.cmd.colorscheme("catppuccin-mocha")
end, as = 'catppuccin' }
