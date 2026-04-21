-- Register Bash support. Auto-installs bashls.
require("langs"):add_spec({
	ft = { "bash", "sh" },

	-- Note the formatter (shfmt) and linter (shellcheck) both integrate
	-- with bash-language-server. Integration with nvim-lint or conform.nvim
	-- is not required.
	mason_auto_install = { "shfmt", "shellcheck", "bash-language-server" },
})
