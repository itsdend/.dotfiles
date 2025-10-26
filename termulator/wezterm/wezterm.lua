local wezterm = require 'wezterm'

local config = wezterm.config_builder()
wezterm.on('update-right-status', function(window, pane)
	window:set_right_status(window:active_workspace())
end)
config.default_workspace = "main"
config.enable_wayland = true
config.default_cursor_style = 'SteadyBlock'

-- colors
config.window_background_opacity = 0.9
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


config.use_ime = true
config.max_fps = 240
config.leader = { key = 'a', mods = 'ALT' }
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
		key = 'l',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Right'
	},
	{
		key = 'j',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Down'
	},
	{
		key = 'k',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Up'
	},
	{
		key = 'h',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection 'Left'
	},
	{
		key = 'g',
		mods = 'LEADER',
		action = wezterm.action.ScrollToBottom
	},
	{
		key = ',',
		mods = 'LEADER',
		action = wezterm.action.ScrollToPrompt(-1)
	},
	{
		key = '.',
		mods = 'LEADER',
		action = wezterm.action.ScrollToPrompt(1)
	},
	{
		key = 'n',
		mods = 'LEADER',
		action = wezterm.action.ScrollByLine(1)
	},
	{
		key = 'm',
		mods = 'LEADER',
		action = wezterm.action.ScrollByLine(-1)
	},
	{
		key = 'q',
		mods = 'LEADER',
		action = wezterm.action.ActivateCopyMode
	},
	{
		key = 'r',
		mods = 'LEADER',
		action = wezterm.action.ReloadConfiguration
	},
	{
		key = 'z',
		mods = 'LEADER',
		action = wezterm.action.IncreaseFontSize
	},
	{
		key = 'x',
		mods = 'LEADER',
		action = wezterm.action.DecreaseFontSize
	},
	{
		key = 'r',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.PromptInputLine	{
			description = 'Enter new name for tab',
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
					end
				end),
		},
	},
	{
		key = 'u',
		mods = 'LEADER',
		action = wezterm.action.SwitchToWorkspace {
			name = 'main',
			spawn = {
				cwd = wezterm.home_dir
			}
		},
	},
	{
		key = 'i',
		mods = 'LEADER',
		action = wezterm.action.SwitchToWorkspace {
			name = 'second',
			spawn = {
				cwd = wezterm.home_dir
			}
		},
	},
	{
		key = 'o',
		mods = 'LEADER',
		action = wezterm.action.SwitchToWorkspace {
			name = 'third',
			spawn = {
				cwd = wezterm.home_dir
			}
		},
	},
	{
		key = 'p',
		mods = 'LEADER',
		action = wezterm.action.SwitchToWorkspace {
			name = 'background',
			spawn = {
				cwd = wezterm.home_dir
			}

		},
	},
	{
		key = 't',
		mods = 'LEADER',
		action = wezterm.action.PromptInputLine	{
			description = 'Enter new name for tab',
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
					wezterm.action.SpawnTab 'CurrentPaneDomain', pane
					)
					window:active_tab():set_title(line)
					end
				end),
		},
	},
	{ key = 'f', mods = 'LEADER', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES'},},
	{ key = 'f', mods = 'LEADER|SHIFT', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|TABS'},},
	{ key = 'a', mods = 'LEADER', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|DOMAINS' },},
	{
		key = 'e',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.CharSelect {
			copy_on_select = false
		},
	},
	{
      key = 'u',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.DisableDefaultAssignment,
    }
}



config.font = wezterm.font('ComicShannsMono Nerd Font', { weight = 420}) -- 547 default
config.font_size = 13
config.cell_width = 1.1
-- wezterm.on('window-config-reloaded', function(window)
-- 	if wezterm.gui.screens().active.name == 'eDP-1' then
-- 		window:set_config_overrides({
-- 			font_size = 19.4
-- 		})
-- 	else
-- 		window:set_config_overrides({
-- 			font_size = 12.9
-- 		})
-- 	end
-- end)

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == 'Vulkan' and gpu.device_type == 'IntegratedGpu' then
		config.webgpu_preferred_adapter = gpu
		config.front_end = 'WebGpu'
		break
	end
end


-- top bar
config.enable_tab_bar = false

config.window_decorations = "NONE"

config.window_close_confirmation = "NeverPrompt"

return config
