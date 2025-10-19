local wezterm = require 'wezterm';

local config = {

  audible_bell = "Disabled",
  visual_bell = {
    fade_in_duration_ms  = 0,
    fade_out_duration_ms = 0,
    target               = 'CursorColor',
  },

  font_size            = 11,
  color_scheme         = "Everforest Dark (Gogh)",
  default_cursor_style = "BlinkingBlock",
  scrollback_lines     = 10000,

  show_new_tab_button_in_tab_bar = false,
  use_fancy_tab_bar = false,
  use_fancy_tab_bar = false,
  enable_tab_bar = true,

  leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 },
  colors = {
    background = '#000000',
    tab_bar = {
      background = "#000000",
      active_tab = {
        bg_color = "#000000",
        fg_color = "#a7c080",
      },
      inactive_tab = {
        bg_color = "#000000",
        fg_color = "#888888",
      },
    },
  },

}

local function map(key, action)
  config.keys = config.keys or {}
  table.insert(config.keys, { key = key, mods = 'LEADER', action = action })
end

map('Enter', wezterm.action.ActivateCopyMode)
map('p', wezterm.action.PasteFrom 'Clipboard')

map('n', wezterm.action.SpawnTab 'CurrentPaneDomain')
map('d', wezterm.action.CloseCurrentPane { confirm = true })

map('h', wezterm.action.ActivatePaneDirection 'Left')
map('j', wezterm.action.ActivatePaneDirection 'Down')
map('k', wezterm.action.ActivatePaneDirection 'Up')
map('l', wezterm.action.ActivatePaneDirection 'Right')

map('b', wezterm.action.ActivateTabRelative(-1))
map('w', wezterm.action.ActivateTabRelative(1))

map('{', wezterm.action.ScrollByPage(1))
map('}', wezterm.action.ScrollByPage(-1))

map('v', wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' })

return config
