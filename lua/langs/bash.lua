-- Register Bash support. Auto-installs bashls.
require("langs"):add_spec({
	ft = { "bash", "sh" },
	mason_auto_install = { "bash-language-server" },
})
