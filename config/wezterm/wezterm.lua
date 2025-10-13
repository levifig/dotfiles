local wezterm = require 'wezterm'

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return "Ayu Mirage"
  else
    return "Catppuccin Latte"
  end
end

return {
  check_for_updates = false,
  color_scheme = scheme_for_appearance(get_appearance()),
  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  use_resize_increments = true,
  use_dead_keys = false,
  initial_cols = 230,
  initial_rows = 60,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,

  -- fonts
  font = wezterm.font("PragmataPro Liga"),
  font_size = 18.0,

  window_padding = {
    left = 20,
    right = 20,
    top = 50,
    bottom = 10,
  },

  -- macos
  send_composed_key_when_left_alt_is_pressed = false,
  use_ime = false,

  keys = {
    { key = "LeftArrow",  mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },
    { key = "RightArrow", mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },
    { key = "UpArrow",    mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },
    { key = "DownArrow",  mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },
    { key = "k",          mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },
    { key = "PageUp",     mods = "SHIFT",      action = "DisableDefaultAssignment" },
    { key = "PageDown",   mods = "SHIFT",      action = "DisableDefaultAssignment" },
  },
}
