-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

-- editor
opt.nu = true
opt.wrap = false
opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.showtabline = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.relativenumber = false
opt.fileencoding = "utf-8"
opt.backspace = "indent,eol,start"
opt.iskeyword:append("-") -- make the dash part of a word

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.showmode = false
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.textwidth = 120
opt.hlsearch = false
opt.incsearch = true
opt.numberwidth = 2
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.title = true
opt.titlestring = "%<%F%=%l/%L - nvim"

-- splits
opt.splitright = true
opt.splitbelow = true

-- history and backups
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.history = 1000

-- clipboard
opt.clipboard = "unnamedplus"

-- copilot
g.copilot_no_tab_map = true
g.copilot_assume_mapped = true

-- misc
opt.updatetime = 60