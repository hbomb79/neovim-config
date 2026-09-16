-- Register Python support. Auto installs based-pyright LSP
require("langs"):add_spec({
	ft = { "python" },
	mason_auto_install = { "basedpyright" },

	on_load = function()
		local function get_python_path()
			-- Check for venv in cwd
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			end

			-- Fallback to homedir
			local homePython = vim.fn.expand("$HOME/python3-env/bin/python")
			if vim.fn.executable(homePython) == 1 then
				return homePython
			end

			-- Fallback to global install
			return "python"
		end

		vim.lsp.config("basedpyright", {
			settings = {
				python = {
					pythonPath = get_python_path(),
				},
			},
		})
	end,
})
