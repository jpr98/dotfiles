-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.color_scheme = "Catppuccin Macchiato"
-- config.default_cursor_style = 'BlinkingBlock' -- 'SteadyBar'
config.font = wezterm.font("MesloLGS NF")
config.font_size = 14

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.2,
}

local action = wezterm.action
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
		action = action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = action.ActivatePaneDirection("Right"),
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
config.tab_and_split_indices_are_zero_based = true
config.show_new_tab_button_in_tab_bar = false
-- and finally, return the configuration to wezterm
return config
