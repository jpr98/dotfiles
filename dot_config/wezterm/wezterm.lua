-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Macchiato"
-- config.default_cursor_style = 'BlinkingBlock' -- 'SteadyBar'
config.font = wezterm.font("MesloLGS NF")
config.font_size = 14

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.2,
}

local action = wezterm.action

wezterm.on("switch-to-left", function(window, pane)
	wezterm.log_info("left callback")
	local tab = window:mux_window():active_tab()
	wezterm.log_info(tab:get_pane_direction("Left"))
	if tab:get_pane_direction("Left") ~= nil then
		window:perform_action(wezterm.action.ActivatePaneDirection("Left"), pane)
	else
		window:perform_action(wezterm.action.ActivateTabRelative(-1), pane)
	end
end)

wezterm.on("switch-to-right", function(window, pane)
	wezterm.log_info("right callback")
	local tab = window:mux_window():active_tab()
	wezterm.log_info(tab:get_pane_direction("Right"))
	if tab:get_pane_direction("Right") ~= nil then
		window:perform_action(wezterm.action.ActivatePaneDirection("Right"), pane)
	else
		window:perform_action(wezterm.action.ActivateTabRelative(1), pane)
	end
end)

config.keys = {
	-- Mux/split panes commands
	{
		key = "d",
		mods = "CMD",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "CMD",
		action = action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "DownArrow",
		mods = "CMD",
		action = action.ActivatePaneDirection("Down"),
	},
	{
		key = "UpArrow",
		mods = "CMD",
		action = action.ActivatePaneDirection("Up"),
	},
	{
		key = "LeftArrow",
		mods = "CMD",
		-- action = action.ActivatePaneDirection("Left"),
		action = action.EmitEvent("switch-to-left"),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		-- action = action.ActivatePaneDirection("Right"),
		action = action.EmitEvent("switch-to-right"),
	},
	-- Natural Text Editing commands
	{
		mods = "OPT",
		key = "LeftArrow",
		action = action.SendKey({ mods = "ALT", key = "b" }),
	},
	{
		mods = "OPT",
		key = "RightArrow",
		action = action.SendKey({ mods = "ALT", key = "f" }),
	},
	{
		mods = "CMD",
		key = "Backspace",
		action = action.SendKey({ mods = "CTRL", key = "u" }),
	},
}

-- Tabs config
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false
config.show_new_tab_button_in_tab_bar = false

for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = wezterm.action.MoveTab(i - 1),
	})
end

-- and finally, return the configuration to wezterm
return config
