return {
  "folke/flash.nvim",
  config = function()
    require("flash").setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
    mode = "exact",
    incremental = false,
  },
  jump = {
    jumplist = true,
    pos = "start",
    history = false,
    register = false,
    nohlsearch = false,
    autojump = false,
  },
  label = {
    uppercase = true,
    exclude = "",
    current = true,
    after = true,
    before = false,
    style = "overlay",
    reuse = "lowercase",
    distance = true,
    min_pattern_length = 0,
    rainbow = {
      enabled = false,
      shade = 5,
    },
  },
  highlight = {
    backdrop = true,
    matches = true,
    priority = 5000,
    groups = {
      match = "FlashMatch",
      current = "FlashCurrent",
      backdrop = "FlashBackdrop",
      label = "FlashLabel",
    },
  },
  modes = {
    search = {
      enabled = true,
      highlight = { backdrop = false },
      jump = { history = true, register = true, nohlsearch = true },
      search = {
        mode = "search",
        max_length = false,
      },
    },
    char = {
      enabled = true,
      config = function(opts)
        opts.autohide = opts.autohide == nil and vim.fn.mode(true):find("no") and vim.v.operator == "y"
        opts.jump_labels = opts.jump_labels == nil and vim.fn.mode(true):find("no") and vim.v.operator ~= "y"
      end,
      autohide = false,
      jump_labels = false,
      multi_line = true,
      label = { exclude = "hjkliardc" },
      keys = { "f", "F", "t", "T", ";", "," },
      char_actions = function(motion)
        return {
          [";"] = "next",
          [","] = "prev",
          [motion:lower()] = "next",
          [motion:upper()] = "prev",
        }
      end,
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { register = false },
    },
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "range" },
      search = { incremental = false },
      label = { before = true, after = true, style = "inline" },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
    treesitter_search = {
      jump = { pos = "range" },
      search = { multi_window = true, wrap = true, incremental = false },
      remote_op = { restore = true },
      label = { before = true, after = true, style = "inline" },
    },
    remote = {
      remote_op = { restore = true, motion = true },
    },
  },
    })
  end,
}