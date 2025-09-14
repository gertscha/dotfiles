-- helper functions
local M = {}

---@diagnostic disable:unused-function

M.is_shell = function(foreground_process_name)
	local shell_names = { "bash", "zsh", "fish", "sh" }
	local process = string.match(foreground_process_name, "[^/\\]+$") or foreground_process_name
	for _, shell in ipairs(shell_names) do
		if process == shell then
			return true
		end
	end
	return false
end


--[[

	WIP to add some session management to wezterm

--]]

-- @param message string
local function notify_info(message)
	require("wezterm").log_info(message)
end
-- @param message string
local function notify_warn(message)
	require("wezterm").log_warn(message)
end
-- @param message string
local function notify_err(message)
	require("wezterm").log_error(message)
end

local home = os.getenv("XDG_DATA_HOME") .. "/"
local defaultPath = home .. "wezterm/workspaces_save.json"
M.workspace_save_path = defaultPath

M.load_workspaces_data = function()
	local file = io.open(M.workspace_save_path, "r")
	if file ~= nil then
		local jsonString = file:read("a")
		local workspaces = require("wezterm").json_parse(jsonString)
		file:close()

		return workspaces
	else
		return
	end
end

--- Recreates the workspace based on the provided data.
--- @param workspace_data table: The data structure containing the saved workspace state.
M.recreate_workspace = function(window, workspace_data)
	local wezterm = require("wezterm")

	if not workspace_data or not workspace_data.tabs then
		wezterm.log_info("Invalid or empty workspace data provided.")
		return
	end
end

M.create_workspace_data = function() end

M.save_workspaces = function() end
M.load_workspaces = function() end

return M
