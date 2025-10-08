return {
  "folke/persistence.nvim",
  config = function()
    require("persistence").setup({
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
      save_empty = false,
    })
  end,
}