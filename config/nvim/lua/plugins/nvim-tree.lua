return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then 
  return 
end

-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = false,
  update_cwd = false,

  actions = {
    open_file = {
      quit_on_open = true,
    },
  },

  diagnostics = {
    enable = false,
  },

  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },

  filters = {
    dotfiles = false,
    custom = { ".git", "node_modules", ".cache" },
  },

  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },

  view = {
    width = 50,
    side = "left",
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },

  renderer = {
    highlight_git = true,
    root_folder_modifier = ":~",
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
  },

  trash = {
    cmd = "trash",
    require_confirm = true,
  },
})

-- Keymaps should be defined in your main config, not in plugin configs

  end,
}