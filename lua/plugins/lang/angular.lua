return {
    {
        'joeveiga/ng.nvim',
        config = function()
            require "lsp.angular"
        end,
        ft = { "typescript", "html" }
    }
}
