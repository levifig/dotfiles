return {
  "williamboman/mason.nvim",
  priority = 1000,
  config = function()
    -- Mason setup is handled in lsp.lua to ensure proper order
    -- This is just the plugin spec
  end,
}