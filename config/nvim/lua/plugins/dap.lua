return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
    "suketa/nvim-dap-ruby",
  },
  config = function()
    local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
  return
end

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
  return
end

local dap_virtual_text_ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if dap_virtual_text_ok then
  dap_virtual_text.setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    filter_references_pattern = '<module',
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
  })
end

-- DAP UI setup
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
    max_value_lines = 100,
  }
})

-- Auto open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- ============================================================================
-- LANGUAGE CONFIGURATIONS
-- ============================================================================

-- Go debugging
local dap_go_ok, dap_go = pcall(require, "dap-go")
if dap_go_ok then
  dap_go.setup({
    dap_configurations = {
      {
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      },
    },
    delve = {
      path = "dlv",
      initialize_timeout_sec = 20,
      port = "${port}",
      args = {},
      build_flags = "",
    },
  })
end

-- Ruby debugging
local dap_ruby_ok, dap_ruby = pcall(require, "dap-ruby")
if dap_ruby_ok then
  dap_ruby.setup()
end

-- JavaScript/TypeScript debugging (Node.js)
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

dap.configurations.typescript = {
  {
    name = 'ts-node (Node2 with ts-node)',
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    runtimeArgs = {'-r', 'ts-node/register'},
    runtimeExecutable = 'node',
    args = {'--inspect', '${file}'},
    sourceMaps = true,
    skipFiles = {'<node_internals>/**', 'node_modules/**'},
  },
  {
    name = 'Jest Debug',
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    runtimeArgs = {'--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest', '--no-coverage', '-t', '${input:testNamePattern}'},
    runtimeExecutable = 'node',
    args = {'${file}'},
    console = 'integratedTerminal',
    sourceMaps = true,
    skipFiles = {'<node_internals>/**', 'node_modules/**'},
  },
}

-- Python debugging
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return '/usr/bin/python3'
    end,
  },
}

-- Signs for breakpoints
vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='🟡', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='▶️', texthl='', linehl='DapStoppedLine', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})

  end,
}