### Language Plugin Specs

This directory contains the plugin definitions on a per-language basis. All the files in this directory
are sourced by the Lazy package manager (see `init.lua`). The intention is that these files specify plugins
which are only loaded when the desired filetype is opened in NeoVim.

>[!NOTE] If you're defining multiple plugins for a language,
> either specify the lazy-loading criteria for all of them, or specify them as direct dependencies of a plugin which *is* lazy loaded.

Each language should have it's own file in this directory which specifies which plugins you wish
to load for a given language. At least one of these plugins should setup the LSP for the language (if there is one to setup);
This is typically done via a `require` in the config/post-load of a language specific plugin.

