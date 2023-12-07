require "lspconfig".ocamllsp.setup {
    ocamllsp = {
        get_language_id = function(_, ftype)
            return ftype
        end
    }
}
