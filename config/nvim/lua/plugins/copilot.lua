return {
  "github/copilot.vim",
  config = function()
    -- Copilot settings are configured via global variables
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
  end,
}