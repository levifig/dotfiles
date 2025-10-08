return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    local status_ok, ibl = pcall(require, "ibl")
if not status_ok then 
  return 
end

ibl.setup({
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = { enabled = false },
  exclude = {
    filetypes = {
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
    },
  },
})

  end,
}