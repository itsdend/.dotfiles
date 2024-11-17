-- Pull in the wezterm API
local wezterm = require 'wezterm'

--hello

-- This will hold the configuration.
local config = wezterm.config_builder()

config.enable_wayland = false

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

config.max_fps = 180
config.leader = { key = 'm', mods = 'CTRL' }
config.keys = {
	{
		key = 'v',
		mods = 'LEADER',
		action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
	},
	{
		key = 's',
		mods = 'LEADER',
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
	},
	{
		key = 'w',
		mods = 'LEADER',
		action = wezterm.action.CloseCurrentPane { confirm = false }
	},
	{
		key = '/',
		mods = 'LEADER',
		action = wezterm.action { PaneSelect = { alphabet = 'hljkdfas' } }
	},
	{
		key = '.',
		mods = 'ALT',
		action = wezterm.action.ActivatePaneDirection 'Right'
	},
	{
		key = ',',
		mods = 'ALT',
		action = wezterm.action.ActivatePaneDirection 'Left'
	},
	{
		key = 'u',
		mods = 'LEADER',
		action = wezterm.action.ScrollByPage(-0.5)
	},
	{
		key = 'd',
		mods = 'LEADER',
		action = wezterm.action.ScrollByPage(0.5)
	},
	{
		key = 'g',
		mods = 'LEADER',
		action = wezterm.action.ScrollToBottom
	},
	{
		key = 'i',
		mods = 'LEADER',
		action = wezterm.action.ScrollToPrompt(-1)
	},
	{
		key = 'a',
		mods = 'LEADER',
		action = wezterm.action.ScrollToPrompt(1)
	},
	{
		key = 'j',
		mods = 'LEADER',
		action = wezterm.action.ScrollByLine(1)
	},
	{
		key = 'k',
		mods = 'LEADER',
		action = wezterm.action.ScrollByLine(-1)
	},
	{
		key = 'q',
		mods = 'LEADER',
		action = wezterm.action.ActivateCopyMode
	}


}

-- fonts
--config.font_dirs = {
--      'C:\\Windows\\Fonts'
--  }
config.font = wezterm.font('ComicShannsMono Nerd Font', { weight = 547 })
config.font_size = 12.9

-- gpu
-- config.front_end = "OpenGL"

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == 'Vulkan' and gpu.device_type == 'IntegratedGpu' then
		config.webgpu_preferred_adapter = gpu
		config.front_end = 'WebGpu'
		break
	end
end


-- top bar
config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_close_confirmation = "NeverPrompt"

-- ubuntu
--config.default_domain = 'WSL:Ubuntu'

-- and finally, return the configuration to wezterm
return config
