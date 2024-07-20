-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.enable_wayland= false,

-- colors

wezterm.gui.enumerate_gpus()
config.window_background_opacity = 0.9
-- This is where you actually apply your config choices
config.colors = {
	foreground = '#EB87B6',
	background = '#24273A',

	cursor_bg = '#FDFD96',
	selection_bg = '#F825C3',

	ansi = {
		'#8A3868',
		'#FC50B4',
		'#4FC8B7',
		'#F9E2AF',
		'#7AC3FF',
		'#D179EE',
		'#F2D5CF',
		'#699DAD'
	},

	brights = {
		'#8A3868',
		'#FC50B4',
		'#4FC8B7',
		'#F9E2AF',
		'#7AC3FF',
		'#D179EE',
		'#F2D5CF',
		'#699DAD'

	}
}

config.keys = {
	{
		key = 'v',
		mods = 'CTRL',
		action = wezterm.action.SplitVertical {domain = 'CurrentPaneDomain'}
	},
	{
		key = 's',
		mods = 'CTRL',
		action = wezterm.action.SplitHorizontal {domain = 'CurrentPaneDomain'}
	},
	{
		key = 'w',
		mods = 'CTRL',
		action = wezterm.action.CloseCurrentPane {confirm = false}
	},
	-- {
	-- 	key = 'm',
	-- 	mods = 'ALT',
	-- 	action = wezterm.action{PaneSelect = {alphabet = 'hljkdfas'}}
	-- },
 	{
		key = '.',
		mods = 'ALT',
		action = wezterm.action.ActivatePaneDirection  'Right'
	},
 	{
		key = ',',
		mods = 'ALT',
		action = wezterm.action.ActivatePaneDirection  'Left'
	}

}

-- fonts
--config.font_dirs = {
--      'C:\\Windows\\Fonts'
--  }
config.font = wezterm.font ('ComicShannsMono Nerd Font', {weight = 547})
config.font_size = 12.9

-- gpu
config.front_end = "OpenGL"

-- top bar
config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_close_confirmation = "NeverPrompt"

-- ubuntu
--config.default_domain = 'WSL:Ubuntu'

-- and finally, return the configuration to wezterm
return config


