local wezterm = require 'wezterm'
local hsl_to_hex = dofile("/hub/include/lua/hsl-to-hex.lua")

local sat_normal, light_normal = 15, 65
local sat_bright, light_bright = 15, 65

local config = {
  audible_bell = "Disabled",
  visual_bell = {fade_in_duration_ms=0, fade_out_duration_ms=0, target='CursorColor'},
  font_size = 11,
  default_cursor_style = "BlinkingBlock",
  scrollback_lines = 10000,
  show_new_tab_button_in_tab_bar = false,
  enable_tab_bar = false,
}

config.color_schemes = {
  ["HSL Base16"] = {
    foreground = hsl_to_hex(0, 0, light_bright),
    background = hsl_to_hex(0, 0, 0),
    cursor_bg  = hsl_to_hex(0, 0, light_bright),
    cursor_fg  = hsl_to_hex(0, 0, 0),
    selection_bg = hsl_to_hex(0, 0, 20),
    selection_fg = hsl_to_hex(0, 0, light_bright),

    ansi = {
      hsl_to_hex(0, 0, 0),
      hsl_to_hex(0, sat_normal, light_normal),
      hsl_to_hex(120, sat_normal, light_normal),
      hsl_to_hex(60, sat_normal, light_normal),
      hsl_to_hex(220, sat_normal, light_normal),
      hsl_to_hex(280, sat_normal, light_normal),
      hsl_to_hex(180, sat_normal, light_normal),
      hsl_to_hex(0, 0, light_normal),
    },

    brights = {
      hsl_to_hex(0, 0, 30),
      hsl_to_hex(0, sat_bright, light_bright),
      hsl_to_hex(120, sat_bright, light_bright),
      hsl_to_hex(60, sat_bright, light_bright),
      hsl_to_hex(220, sat_bright, light_bright),
      hsl_to_hex(280, sat_bright, light_bright),
      hsl_to_hex(180, sat_bright, light_bright),
      hsl_to_hex(0, 0, light_bright),
    },
  },
}

config.color_scheme = "HSL Base16"

return config
