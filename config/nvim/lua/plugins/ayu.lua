return {
  "Shatur/neovim-ayu",
  priority = 1000,
  config = function()
    local ayu = require("ayu")
    
    ayu.setup({
      mirage = true, -- Use ayu-mirage variant
      overrides = {},
    })
    
    -- Set colorscheme after setup
    vim.schedule(function()
      vim.cmd.colorscheme("ayu")
    end)
  end,
}