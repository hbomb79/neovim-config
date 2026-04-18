-- Register SQL support. Auto-installs sqlfluff linter.
require("langs"):add_spec({
	ft = { "sql" },

	linters = { "sqlfluff" },
	mason_auto_install = { "sqlfluff" },

	on_load = function()
		-- Override default sqlfluff behaviour
		local sqlfluff = require("lint").linters.sqlfluff
		sqlfluff.cmd = vim.fn.expand("$MASON/bin/sqlfluff")
		sqlfluff.args = { "lint", "--dialect", "postgres", "--format=json", "-" }
	end,
})
