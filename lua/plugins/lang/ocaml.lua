return {
    {
        'tjdevries/ocaml.nvim',
        config = function()
            require("ocaml").update()
            require("ocaml").setup()
            require "lsp.ocaml"
        end,
        ft = { "ocaml" }
    }
}
