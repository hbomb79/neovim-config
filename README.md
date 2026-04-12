## Configuration Structure:

```
/init.lua                 <- Language registration (LSPs, formatters, etc)
/lua 
    /lspconfig            <- Large LSP config that has been moved to own file
    /plugins              <- All Lazy.nvim plugin specs
        /config           <- Large plugin config when too large to inline
        /lang             <- Plugins grouped by the specific language they target
```

