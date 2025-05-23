-- Pull in the wezterm API
local wezterm = require 'wezterm'

--hello

-- This will hold the configuration.
local config = wezterm.config_builder()
wezterm.on('update-right-status', function(window, pane)
	window:set_right_status(window:active_workspace())
end)
config.default_workspace = "main"
config.enable_wayland = true
config.default_cursor_style = 'SteadyBlock'

-- colors
wezterm.log_info("Starting WezTerm with debugging enabled.")

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

function LOL()
	local success, stdout, stderr = wezterm.run_child_process {'wl-paste'}
-- Remove the trailing newline (if it exists)
  stdout = stdout:gsub("\n$", "")
	return wezterm.action.SendString (stdout)
end

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
		key = 'e',
		mods = 'LEADER',
		action = wezterm.action.ScrollByPage(-0.5)
	},
	{
		key = 'r',
		mods = 'LEADER',
		action = wezterm.action.ScrollByPage(0.5)
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
		key = 't',
		mods = 'LEADER',
		action = wezterm.action.ReloadConfiguration
	},
	-- {
	-- 	key = 't',
	-- 	mods = 'SHIFT|ALT',
	-- 	action = wezterm.action.SpawnTab 'DefaultDomain',
	-- },
	-- Switch to the default workspace
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
	{ key = 'f', mods = 'LEADER', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },},
	{ key = 'a', mods = 'LEADER', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|DOMAINS' },},
	{
		key = 'e',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.CharSelect {
			copy_on_select = false
		},
	},
	{
		key="y", mods="LEADER", action= wezterm.action.Multiple{
		wezterm.action.ReloadConfiguration,
			LOL()}
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
-- config.font_size = 19.4

-- This doesn't work well on a dual screen setup, and is hopefully a temporary solution to the font rendering oddities
-- shown in https://github.com/wez/wezterm/issues/4096. Ideally I'll switch to using `dpi_by_screen` at some point,
-- but for now 11pt @ 109dpi seems to be the most stable for font rendering on my 38" ultrawide LG monitor here.
--
-- THIS IS THE CONFIG FOR XWAYLAND FOR THE FONT SIZE DEPENDING ON THE MONITOR
--
--
wezterm.on('window-config-reloaded', function(window)
	if wezterm.gui.screens().active.name == 'eDP-1' then
		window:set_config_overrides({
			-- font_size = 19.4 -- this is if its on xwayland
			font_size = 12.9
		})
	else
		window:set_config_overrides({
			font_size = 12.9
		})
	end
end)
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

config.window_decorations = "NONE"

config.window_close_confirmation = "NeverPrompt"

-- ubuntu
--config.default_domain = 'WSL:Ubuntu'

-- and finally, return the configuration to wezterm
return config
