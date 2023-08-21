return {
    {
        'scalameta/nvim-metals',
        ft = { "scala", "sbt" },
        config = function() require "lsp.scala" end
    }
}
