-- Checks that the Neovim config is up to date
-- with the origin.
local CONF_DIR = vim.fn.expand("$HOME/.config/nvim/")

vim.fn.jobstart({ "git", "fetch" }, {
	cwd = CONF_DIR,
	on_exit = function(_, fetchexitcode, _)
		if fetchexitcode ~= 0 then
			vim.notify(
				"Failed to check for config updates: git fetch failed: exit code: " .. tostring(fetchexitcode),
				vim.log.levels.ERROR
			)
		end

		local is_behind = false
		vim.fn.jobstart({ "git", "rev-list", "--count", "--left-only", "HEAD...origin/HEAD" }, {
			cwd = CONF_DIR,
			clear_env = true,
			on_stdout = function(_, data, name)
				if name == "stdout" and #data > 0 then
					local num = tonumber(data[1])
					if num == "number" and num > 0 then
						is_behind = true
					end
				end

				vim.notify("Saw data: " .. tostring(data) .. ", is_behind: " .. tostring(is_behind))
			end,
			on_exit = function(_, revexitcode, _)
				if revexitcode ~= 0 then
					vim.notify(
						"Failed to check for config updates: git rev-list failed: exit code: " .. tostring(revexitcode),
						vim.log.levels.ERROR
					)
				end

				if is_behind then
					vim.notify(
						"Neovim config is outdated! Please update your config by running `git pull` in your config dir ("
							.. CONF_DIR
							.. ").",
						vim.log.levels.WARN
					)
				else
					vim.notify("Neovim config is up-to-date!", vim.log.levels.INFO)
				end
			end,
		})
	end,
})
