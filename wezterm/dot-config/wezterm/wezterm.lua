local wezterm = require("wezterm")
local theme = require("vague")
local M = require("helpers")

local act = wezterm.action
local mux = wezterm.mux

wezterm.log_info("Loaded Config")

------------------------------------ Config -----------------------------------
local background_opacity = 0.6
local config = {
	-- some options to use while changing the config
	automatically_reload_config = true,
	warn_about_missing_glyphs = true,
	enable_kitty_graphics = true,

	---------------------------------- Looks ----------------------------------
	colors = theme.colors(),
	font_size = 11,
	-- check available fonts: wezterm ls-fonts --list-system
	font = wezterm.font("MartianMono Nerd Font Mono"),
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.6,
	},
	-- window_background_opacity = background_opacity,

	-------------------------------- Behaviour --------------------------------
	default_prog = { "fish" },
	default_cwd = "~",

	----------------------------- Window Settings -----------------------------
	window_frame = {
		border_left_width = "0cell",
		border_right_width = "0cell",
		border_bottom_height = "0cell",
		border_top_height = "0cell",
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	window_content_alignment = {
		horizontal = "Left",
		vertical = "Top",
	},

	scrollback_lines = 10000,
	enable_scroll_bar = false,
	hide_mouse_cursor_when_typing = true,

	---------------------------------- Tab Bar --------------------------------
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	-- colors are set in theme
	hide_tab_bar_if_only_one_tab = true,

	----------------------------------- Bell ----------------------------------
	audible_bell = "Disabled",
	visual_bell = {
		fade_in_duration_ms = 75,
		fade_out_duration_ms = 75,
		target = "CursorColor",
	},

	------------------------------- Keybindings -------------------------------
	disable_default_key_bindings = true,
	keys = {
		-- { key = "R", mods = "CTRL|ALT", action = act.ReloadConfiguration },
		{ key = "p", mods = "CTRL|ALT", action = wezterm.action.ShowLauncher },
		{ key = "O", mods = "CTRL|ALT|SHIFT", action = act.ShowDebugOverlay },
		-- window
		{ key = "n", mods = "CTRL|ALT", action = act.SpawnWindow },
		{ key = "f", mods = "CTRL|ALT", action = act.ToggleFullScreen },
		{ key = "m", mods = "CTRL|ALT", action = act.Hide },
		{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = act.ResetFontSize },
		{ key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
		{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
		{ key = "Home", mods = "SHIFT", action = act.ScrollToTop },
		{ key = "End", mods = "SHIFT", action = act.ScrollToBottom },
		{ key = "I", mods = "CTRL|ALT", action = act.EmitEvent("toggle-opacity") },
		-- tabs
		{ key = "t", mods = "CTRL|ALT", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "CTRL|ALT", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "[", mods = "CTRL|ALT", action = act.ActivateTabRelative(-1) },
		{ key = "]", mods = "CTRL|ALT", action = act.ActivateTabRelative(1) },
		{ key = "1", mods = "CTRL|ALT", action = act.ActivateTab(0) },
		{ key = "2", mods = "CTRL|ALT", action = act.ActivateTab(1) },
		{ key = "3", mods = "CTRL|ALT", action = act.ActivateTab(2) },
		{ key = "4", mods = "CTRL|ALT", action = act.ActivateTab(3) },
		{ key = "5", mods = "CTRL|ALT", action = act.ActivateTab(4) },
		{ key = "6", mods = "CTRL|ALT", action = act.ActivateTab(5) },
		{ key = "7", mods = "CTRL|ALT", action = act.ActivateTab(6) },
		{ key = "8", mods = "CTRL|ALT", action = act.ActivateTab(7) },
		{ key = "9", mods = "CTRL|ALT", action = act.ActivateTab(8) },
		{
			key = "T",
			mods = "CTRL|ALT",
			action = act.ShowLauncherArgs({ flags = "TABS" }),
		},
		-- panes
		{ key = '"', mods = "ALT|CTRL", action = act.SplitVertical },
		{ key = '"', mods = "SHIFT|ALT|CTRL", action = act.SplitVertical },
		{ key = "%", mods = "ALT|CTRL", action = act.SplitHorizontal },
		{ key = "%", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal },
		{ key = "q", mods = "CTRL|ALT", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "z", mods = "CTRL|ALT", action = act.TogglePaneZoomState },
		{ key = "h", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "l", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Right") },
		{ key = "k", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "j", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Down") },
		{ key = "L", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Right", 2 }) },
		{ key = "H", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Left", 2 }) },
		{ key = "K", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Up", 2 }) },
		{ key = "J", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Down", 2 }) },
		-- workspaces
		{ key = "{", mods = "CTRL|ALT", action = act.SwitchWorkspaceRelative(-1) },
		{ key = "}", mods = "CTRL|ALT", action = act.SwitchWorkspaceRelative(1) },
		-- { key = "d", mods = "CTRL|ALT", action = M.save_workspaces },
		-- { key = "f", mods = "CTRL|ALT", action = M.load_workspaces },
		{ key = "s", mods = "CTRL|ALT", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
		{
			-- Prompt for a new name for the current workspace
			key = "S",
			mods = "CTRL|ALT",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter new name for current workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					if line then
						mux.rename_workspace(window:active_workspace(), line)
					end
				end),
			}),
		},
		{ key = "a", mods = "CTRL|ALT", action = act.SwitchToWorkspace({ name = "default" }) },
		{
			-- Prompt for a workspace name (create it) and switch to it
			key = "A",
			mods = "CTRL|ALT",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for (new) workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					if line then
						if line == "" then -- use random name
							window:perform_action(act.SwitchToWorkspace, pane)
						else
							window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
						end
					end
				end),
			}),
		},
		-- modes
		{ key = "x", mods = "CTRL|ALT", action = act.ActivateCopyMode },
	},

	key_tables = {
		copy_mode = {
			{ key = "Escape", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
			{ key = "c", mods = "CTRL", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
			{ key = "q", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
			{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
			{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
			{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
			{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
			{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
			{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
			{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
			{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
			{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
			{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
			{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			{
				key = "y",
				mods = "NONE",
				action = act.Multiple({
					{ CopyTo = "ClipboardAndPrimarySelection" },
					{ Multiple = { "ScrollToBottom", { CopyMode = "Close" } } },
				}),
			},
			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
			{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
		},
	},
}

------------------------------------ Events -----------------------------------

-- startup events are: gui-startup and mux-startup

-- wezterm.on("window-config-reloaded", function(window, pane)
-- 	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
-- end)

wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = background_opacity
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- use hyperlinks in terminal, ls navigation, open files
wezterm.on("open-uri", function(window, pane, uri)
	local editor = "nvim"
	if uri:find("^file:") == 1 and not pane:is_alt_screen_active() then
		-- We're processing an hyperlink and the uri format should be: file://[HOSTNAME]/PATH[#linenr]
		-- Also the pane is not in an alternate screen (an editor, less, etc)
		local url = wezterm.url.parse(uri)
		if M.is_shell(pane:get_foreground_process_name()) then
			-- A shell has been detected. Wezterm can check the file type directly
			-- figure out what kind of file we're dealing with
			local success, stdout, _ = wezterm.run_child_process({
				"file",
				"--brief",
				"--mime-type",
				url.file_path,
			})
			if success then
				if stdout:find("directory") then
					pane:send_text(wezterm.shell_join_args({ "cd", url.file_path }) .. "\r")
					pane:send_text(wezterm.shell_join_args({
						"ls",
						"-lAh",
					}) .. "\r")
					return false
				end

				if stdout:find("text") then
					if url.fragment then
						pane:send_text(wezterm.shell_join_args({
							editor,
							"+" .. url.fragment,
							url.file_path,
						}) .. "\r")
					else
						pane:send_text(wezterm.shell_join_args({ editor, url.file_path }) .. "\r")
					end
					return false
				end
			end
		else
			-- No shell detected, we're probably connected with SSH, use fallback command
			local edit_cmd = url.fragment and editor .. " +" .. url.fragment .. ' "$_f"' or editor .. ' "$_f"'
			local cmd = '_f="'
				.. url.file_path
				.. '"; { test -d "$_f" && { cd "$_f" ; ls -a -p --hyperlink --group-directories-first; }; } '
				.. '|| { test "$(file --brief --mime-type "$_f" | cut -d/ -f1 || true)" = "text" && '
				.. edit_cmd
				.. "; }; echo"
			pane:send_text(cmd .. "\r")
			return false
		end
	end
	-- without a return value, we allow default actions
end)

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

return config
