-- Custom keymaps configuration

-- Set leader keys FIRST
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local keymap = vim.keymap
local opts = { silent = true }

keymap.set("i", "jk", "<ESC>", opts)                  -- "jk" in insert mode emulates <ESC>
keymap.set("n", "<leader><space>", ":nohl<CR>", opts) -- disable highlights with <leader><space>

keymap.set("n", "x", '"_x', opts)                     -- when deleting a char with "x", don't save contents to register
keymap.set("n", "<leader>+", "<C-a>", opts)           -- increment number
keymap.set("n", "<leader>-", "<C-x>", opts)           -- decrement number

keymap.set("n", "<leader>ev", ":e $MYVIMRC<CR>")      -- Reload NeoVim configuration
keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>") -- Reload NeoVim configuration

-- Map ctrl-c to esc
keymap.set("i", "<C-c>", "<esc>", opts)

-- Paste over selected text
keymap.set("v", "p", '"_dP', opts)

-- Better Indentation
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Escape is acting as tab in normal mode
keymap.set("n", "<esc>", "<NOP>", opts)

-- Buffers
-- Delete buffer
keymap.set("n", "<c-x>", ":bd<CR>", opts)

-- Navigate buffers
keymap.set("n", "bn", ":bnext<CR>", opts)
keymap.set("n", "bl", ":bnext<CR>", opts)
keymap.set("n", "bv", ":bprevious<CR>", opts)
keymap.set("n", "bh", ":bprevious<CR>", opts)
keymap.set("n", "BN", ":bprevious<CR>", opts)

keymap.set("n", "<c-]>", ":bnext<CR>", opts)
keymap.set("n", "<c-[>", ":bprevious<CR>", opts)

-- File Explorer
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>", opts)
keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Splits
-- Resize splits with alt+cursor keys
keymap.set("n", "<M-Up>", ":resize +2<CR>", opts)
keymap.set("n", "<M-Down>", ":resize -2<CR>", opts)
keymap.set("n", "<M-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<M-Right>", ":vertical resize +2<CR>", opts)

-- Formatting
keymap.set("n", "<leader>f", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format buffer" })

-- Linting
keymap.set("n", "<leader>l", function()
  local ok, lint = pcall(require, "lint")
  if ok then
    local ft = vim.bo.filetype
    if lint.linters_by_ft[ft] and #lint.linters_by_ft[ft] > 0 then
      lint.try_lint()
    else
      vim.notify("No linters configured for filetype: " .. ft, vim.log.levels.INFO)
    end
  else
    vim.notify("nvim-lint not available", vim.log.levels.ERROR)
  end
end, { desc = "Trigger linting" })

-- Project management
keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find projects" })

-- Session management
keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })
keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end,
  { desc = "Restore last session" })
keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save current session" })

-- Git
keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open diff view" })
keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "File history" })
keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })

-- Testing
keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,
  { desc = "Run current file tests" })
keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end,
  { desc = "Open test output" })

-- Debugging
keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue debugging" })
keymap.set("n", "<leader>ds", function() require("dap").step_over() end, { desc = "Step over" })
keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step into" })
keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step out" })
keymap.set("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Open REPL" })
keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })

-- Harpoon
keymap.set("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = "Add file to harpoon" })
keymap.set("n", "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
  { desc = "Toggle harpoon menu" })
keymap.set("n", "<leader>h1", function() require("harpoon"):list():select(1) end, { desc = "Go to harpoon file 1" })
keymap.set("n", "<leader>h2", function() require("harpoon"):list():select(2) end, { desc = "Go to harpoon file 2" })
keymap.set("n", "<leader>h3", function() require("harpoon"):list():select(3) end, { desc = "Go to harpoon file 3" })
keymap.set("n", "<leader>h4", function() require("harpoon"):list():select(4) end, { desc = "Go to harpoon file 4" })

-- Copilot
keymap.set("i", "<leader><tab>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

-- Claude Code
vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
