return {
  "stevearc/dressing.nvim",
  config = function()
    require("dressing").setup({
  input = {
    enabled = true,
    default_prompt = "Input:",
    prompt_align = "left",
    insert_only = true,
    start_in_insert = true,
    border = "rounded",
    relative = "cursor",
    prefer_width = 40,
    width = nil,
    max_width = { 140, 0.9 },
    min_width = { 20, 0.2 },
    buf_options = {},
    win_options = {
      winblend = 10,
      wrap = false,
    },
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },
  },
  select = {
    enabled = true,
    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
    trim_prompt = true,
    telescope = require("telescope.themes").get_dropdown(),
  },
    })
  end,
}