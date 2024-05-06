-- Checks that the Neovim config is up to date
-- with the origin.
local CONF_DIR = vim.fn.expand("$HOME/.config/nvim/")

vim.fn.jobstart({ "lua/bin/check-update.sh" }, {
	cwd = CONF_DIR,
	on_exit = function(_, fetchexitcode, _)
		if fetchexitcode ~= 0 and fetchexitcode ~= 1 then
			vim.notify(
				"Failed to check for config updates: exit code: " .. tostring(fetchexitcode),
				vim.log.levels.ERROR
			)
		end

		if fetchexitcode == 1 then
			vim.notify(
				"Neovim config is outdated! Please update your config by running `:lua UpdateConfig()`",
				vim.log.levels.WARN
			)
		else
			vim.notify("Neovim config is up-to-date!", vim.log.levels.TRACE)
		end
	end,
})

function UpdateConfig()
	vim.notify("Updating config... Please wait...", vim.log.levels.INFO)

	vim.fn.jobstart({ "lua/bin/do-update.sh" }, {
		cwd = CONF_DIR,
		on_exit = function(_, exitcode, _)
			if exitcode ~= 0 then
				vim.notify("Failed to perform, exit code: " .. tostring(exitcode), vim.log.levels.ERROR)
				return
			end

			vim.notify("Config updated!", vim.log.levels.INFO)
		end,
	})
end
