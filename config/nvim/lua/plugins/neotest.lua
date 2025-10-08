return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    local status_ok, neotest = pcall(require, "neotest")
if not status_ok then
  return
end

neotest.setup({
  adapters = {
    -- Ruby/Rails testing with RSpec
    require("neotest-rspec")({
      rspec_cmd = function()
        return vim.tbl_flatten({
          "bundle",
          "exec",
          "rspec",
        })
      end,
      transform_spec_path = function(path)
        local prefix = require("neotest-rspec").root(path)
        return string.sub(path, string.len(prefix) + 2, -1)
      end,
      results_path = "tmp/rspec.output"
    }),

    -- Go testing
    require("neotest-go")({
      experimental = {
        test_table = true,
      },
      args = { "-count=1", "-timeout=60s" }
    }),

    -- JavaScript/TypeScript testing with Jest
    require("neotest-jest")({
      jestCommand = "npm test --",
      jestConfigFile = "jest.config.js",
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    }),
  },

  discovery = {
    enabled = true,
    concurrent = 1,
  },

  running = {
    concurrent = true,
  },

  summary = {
    enabled = true,
    animated = true,
    follow = true,
    expand_errors = true,
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      output = "o",
      short = "O",
      attach = "a",
      jumpto = "i",
      stop = "u",
      run = "r",
      debug = "d",
      mark = "m",
      run_marked = "R",
      debug_marked = "D",
      clear_marked = "M",
      target = "t",
      clear_target = "T",
      next_failed = "J",
      prev_failed = "K",
      watch = "w",
    },
  },

  output = {
    enabled = true,
    open_on_run = "short",
  },

  output_panel = {
    enabled = true,
    open = "botright split | resize 15",
  },

  quickfix = {
    enabled = true,
    open = false,
  },

  status = {
    enabled = true,
    virtual_text = false,
    signs = true,
  },

  strategies = {
    integrated = {
      height = 40,
      width = 120,
    },
  },

  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✖",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = "✓",
    running = "●",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = "○",
    unknown = "?",
  },

  highlights = {
    adapter_name = "NeotestAdapterName",
    border = "NeotestBorder",
    dir = "NeotestDir",
    expand_marker = "NeotestExpandMarker",
    failed = "NeotestFailed",
    file = "NeotestFile",
    focused = "NeotestFocused",
    indent = "NeotestIndent",
    marked = "NeotestMarked",
    namespace = "NeotestNamespace",
    passed = "NeotestPassed",
    running = "NeotestRunning",
    select_win = "NeotestWinSelect",
    skipped = "NeotestSkipped",
    target = "NeotestTarget",
    test = "NeotestTest",
    unknown = "NeotestUnknown",
  },
})

  end,
}