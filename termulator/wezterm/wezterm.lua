local wezterm = require 'wezterm'

local config = wezterm.config_builder()
wezterm.on('update-right-status', function(window, pane)
	window:set_right_status(window:active_workspace())
end)

local claude_previous_tab_id = nil

wezterm.on('claude-toggle', function(window, pane)
	local mux_win = window:mux_window()
	local tabs = mux_win:tabs()
	local current_tab = mux_win:active_tab()
	local current_tab_id = current_tab:tab_id()

	local claude_tab = nil
	for _, tab in ipairs(tabs) do
		if tab:get_title() == 'claude' then
			claude_tab = tab
			break
		end
	end

	if claude_tab == nil then
		local user_vars = pane:get_user_vars()
		local nix_shell = user_vars['NIX_SHELL']

		local cmd
		if nix_shell == 'erlang' then
			cmd = { 'bash', '-c', 'nix develop ~/.dotfiles#erlang --command bash -c "claude; exec bash -i"' }
		elseif nix_shell == 'elixir' then
			cmd = { 'bash', '-c', 'nix develop ~/.dotfiles#elixir --command bash -c "claude; exec bash -i"' }
		else
			cmd = { 'bash', '-c', 'claude; exec bash -i' }
		end

		claude_previous_tab_id = current_tab_id
		local new_tab, _, _ = mux_win:spawn_tab({ args = cmd })
		new_tab:set_title('claude')

	elseif claude_tab:tab_id() == current_tab_id then
		if claude_previous_tab_id then
			for _, tab in ipairs(tabs) do
				if tab:tab_id() == claude_previous_tab_id then
					tab:activate()
					break
				end
			end
		end
	else
		claude_previous_tab_id = current_tab_id
		claude_tab:activate()
	end
end)
config.default_workspace = "main"
config.enable_wayland = true
config.default_cursor_style = 'SteadyBlock'
config.automatically_reload_config = true;

-- Resolve the current theme path
local home = os.getenv("HOME")
local theme_path = home .. "/.config/inu_nix/themes/current/wezterm.lua"
wezterm.add_to_config_reload_watch_list(home .. "/.config/inu_nix/themes/current/wezterm.lua")
-- Load the colors table from the theme
local theme_colors = dofile(theme_path)

-- colors
config.window_background_opacity = 0.9
config.colors = theme_colors.colors


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
	{ key = 'y', mods = 'LEADER', action = wezterm.action.EmitEvent 'claude-toggle' },
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
