return {
  "folke/ts-comments.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("ts-comments").setup()
  end,
}