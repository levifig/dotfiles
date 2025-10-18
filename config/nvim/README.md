# Personal Neovim Configuration

A comprehensive Neovim configuration built with lazy.nvim, optimized for modern development workflows with Ruby/Rails, Go, JavaScript/TypeScript, Python, and DevOps tools.

## Table of Contents

- [Quick Start](#quick-start)
- [Key Features](#key-features)
- [Configuration Structure](#configuration-structure)
- [Complete Keybindings Reference](#complete-keybindings-reference)
- [Installed Plugins](#installed-plugins)
- [Installation](#installation)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

## Quick Start

### Basic Usage

**Leader key**: `,` (comma)

**Most Common Commands**:
- `,<space>` - Clear search highlights
- `,<leader>` - Find files (Telescope)
- `,e` - Toggle file explorer
- `,fg` - Live grep in project
- `,gg` - Open LazyGit
- `K` - Show hover documentation (LSP)

### First Time Setup

1. Clone this configuration to `~/.config/nvim`
2. Start Neovim - plugins will auto-install
3. Run `:checkhealth` to verify setup
4. Run `:checkhealth amp` to check Amp integration

## Key Features

### Editor Configuration
- **Leader key**: `,` (comma)
- **Tab settings**: 2 spaces, smart indentation
- **Line numbers**: Enabled (no relative numbers)
- **Search**: Case-insensitive with smart case
- **Clipboard**: System clipboard integration
- **No swap files**: Undo file enabled for persistence
- **Auto-format**: Format on save with language-specific formatters
- **Auto-lint**: Real-time code quality checks

### Core Capabilities
- **Multi-language LSP**: Native LSP with Mason auto-installer
- **AI Assistance**: Copilot and Amp.nvim integration
- **Testing Framework**: Neotest with RSpec, Jest, Go support
- **Debugging**: nvim-dap with Ruby/Go/JS/Python adapters
- **Git Workflow**: Advanced diff viewer, LazyGit, and gitsigns
- **Project Management**: Auto-detection, session persistence, Harpoon
- **Modern UI**: Noice, lualine, which-key, and notifications

## Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # All key mappings (centralized)
│   │   ├── lazy.lua        # Lazy.nvim setup
│   │   └── options.lua     # Vim options
│   └── plugins/            # Self-contained plugin specifications
│       ├── amp.lua         # Amp AI integration
│       ├── ayu.lua         # Colorscheme
│       ├── completion.lua  # nvim-cmp setup
│       ├── copilot.lua     # GitHub Copilot
│       ├── dap.lua         # Debugging adapter
│       ├── diffview.lua    # Git diff viewer
│       ├── gitsigns.lua    # Git decorations
│       ├── lsp.lua         # Language servers
│       ├── neotest.lua     # Testing framework
│       ├── telescope.lua   # Fuzzy finder
│       └── ...             # 50+ other plugins
└── lazy-lock.json          # Plugin version lock file
```

## Complete Keybindings Reference

### Core Editor Keybindings

#### Mode Control
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Insert | `jk` | `<ESC>` | Exit insert mode |
| Insert | `<C-c>` | `<ESC>` | Exit insert mode (alternative) |

#### General Operations
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader><space>` | `:nohl` | Clear search highlights |
| Normal | `<leader>ev` | `:e $MYVIMRC` | Edit Neovim config |
| Normal | `<leader>sv` | `:source $MYVIMRC` | Reload Neovim config |
| Normal | `x` | `"_x` | Delete char without saving to register |
| Normal | `<leader>+` | `<C-a>` | Increment number under cursor |
| Normal | `<leader>-` | `<C-x>` | Decrement number under cursor |
| Visual | `p` | `"_dP` | Paste over selection without yanking |

#### Indentation
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Visual | `<` | `<gv` | Indent left and reselect |
| Visual | `>` | `>gv` | Indent right and reselect |

### Buffer Management

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<C-x>` | `:bd` | Delete current buffer |
| Normal | `bn` | `:bnext` | Next buffer |
| Normal | `bl` | `:bnext` | Next buffer (alternative) |
| Normal | `bv` | `:bprevious` | Previous buffer |
| Normal | `bh` | `:bprevious` | Previous buffer (alternative) |
| Normal | `BN` | `:bprevious` | Previous buffer (uppercase) |
| Normal | `<C-]>` | `:bnext` | Next buffer (bracket) |
| Normal | `<C-[>` | `:bprevious` | Previous buffer (bracket) |

### Window & Split Management

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<M-Up>` | `:resize +2` | Increase window height |
| Normal | `<M-Down>` | `:resize -2` | Decrease window height |
| Normal | `<M-Left>` | `:vertical resize -2` | Decrease window width |
| Normal | `<M-Right>` | `:vertical resize +2` | Increase window width |

### File Explorer (NvimTree)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>e` | `:NvimTreeToggle` | Toggle file explorer |

### Fuzzy Finding (Telescope)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader><leader>` | `:Telescope find_files` | Find files in project |
| Normal | `<leader>fg` | `:Telescope live_grep` | Live grep in project |
| Normal | `<leader>fb` | `:Telescope buffers` | Search open buffers |
| Normal | `<leader>fp` | `:Telescope projects` | Find and switch projects |

### LSP (Language Server Protocol)

#### Navigation
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `gd` | `vim.lsp.buf.definition` | Go to definition |
| Normal | `gD` | `vim.lsp.buf.declaration` | Go to declaration |
| Normal | `gr` | `telescope.lsp_references` | Go to references |
| Normal | `gI` | `vim.lsp.buf.implementation` | Go to implementation |
| Normal | `<leader>D` | `vim.lsp.buf.type_definition` | Type definition |
| Normal | `<leader>ds` | `telescope.lsp_document_symbols` | Document symbols |
| Normal | `<leader>ws` | `telescope.lsp_dynamic_workspace_symbols` | Workspace symbols |

#### Actions
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>rn` | `vim.lsp.buf.rename` | Rename symbol |
| Normal | `<leader>ca` | `vim.lsp.buf.code_action` | Code action |
| Normal | `K` | `vim.lsp.buf.hover` | Hover documentation |
| Normal | `<C-k>` | `vim.lsp.buf.signature_help` | Signature documentation |

#### Workspace
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>wa` | `vim.lsp.buf.add_workspace_folder` | Add workspace folder |
| Normal | `<leader>wr` | `vim.lsp.buf.remove_workspace_folder` | Remove workspace folder |
| Normal | `<leader>wl` | Print workspace folders | List workspace folders |

#### Formatting & Linting
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>f` | `conform.format()` | Format buffer |
| Normal | `<leader>l` | `lint.try_lint()` | Trigger linting |

### Git Integration

#### LazyGit & Diffview
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>gg` | `:LazyGit` | Open LazyGit |
| Normal | `<leader>gd` | `:DiffviewOpen` | Open diff view |
| Normal | `<leader>gh` | `:DiffviewFileHistory` | File history |

#### Gitsigns (Hunk Operations)
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `]c` | Next hunk | Go to next git hunk |
| Normal | `[c` | Previous hunk | Go to previous git hunk |
| Normal | `<leader>hs` | Stage hunk | Stage current hunk |
| Normal | `<leader>hr` | Reset hunk | Reset current hunk |
| Normal | `<leader>hS` | Stage buffer | Stage entire buffer |
| Normal | `<leader>hu` | Undo stage hunk | Undo last stage |
| Normal | `<leader>hR` | Reset buffer | Reset entire buffer |
| Normal | `<leader>hp` | Preview hunk | Preview hunk diff |
| Normal | `<leader>hb` | Blame line | Show git blame |
| Normal | `<leader>hd` | Diff this | Show diff for current file |
| Normal | `<leader>hD` | Diff this ~ | Show diff against HEAD~ |
| Normal | `<leader>tb` | Toggle line blame | Toggle inline blame |
| Normal | `<leader>td` | Toggle deleted | Toggle deleted lines |
| Visual | `<leader>hs` | Stage hunk | Stage selected hunk |
| Visual | `<leader>hr` | Reset hunk | Reset selected hunk |
| Operator | `ih` | Select hunk | Git hunk text object |

#### Diffview Navigation (Inside Diffview)
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<Tab>` | Next entry | Open diff for next file |
| Normal | `<S-Tab>` | Previous entry | Open diff for previous file |
| Normal | `gf` | Goto file | Open file in previous tab |
| Normal | `<C-w><C-f>` | Goto file split | Open file in new split |
| Normal | `<C-w>gf` | Goto file tab | Open file in new tab |
| Normal | `<leader>e` | Focus files | Focus file panel |
| Normal | `<leader>b` | Toggle files | Toggle file panel |
| Normal | `g<C-x>` | Cycle layout | Cycle through layouts |
| Normal | `[x` | Previous conflict | Jump to previous conflict |
| Normal | `]x` | Next conflict | Jump to next conflict |
| Normal | `<leader>co` | Choose ours | Choose OURS version |
| Normal | `<leader>ct` | Choose theirs | Choose THEIRS version |
| Normal | `<leader>cb` | Choose base | Choose BASE version |
| Normal | `<leader>ca` | Choose all | Choose all versions |
| Normal | `dx` | Delete conflict | Delete conflict region |
| Normal | `g?` | Help | Open help panel |

#### Diffview File Panel
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `j` / `<Down>` | Next entry | Move to next file |
| Normal | `k` / `<Up>` | Previous entry | Move to previous file |
| Normal | `<CR>` / `o` | Select entry | Open diff |
| Normal | `-` | Toggle stage | Stage/unstage entry |
| Normal | `S` | Stage all | Stage all entries |
| Normal | `U` | Unstage all | Unstage all entries |
| Normal | `X` | Restore entry | Restore to left side state |
| Normal | `L` | Commit log | Open commit log |
| Normal | `R` | Refresh files | Update file list |
| Normal | `i` | Listing style | Toggle list/tree view |
| Normal | `f` | Flatten dirs | Toggle flatten directories |

#### Diffview File History Panel
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `g!` | Options | Open option panel |
| Normal | `<C-A-d>` | Open in diffview | Open commit in diffview |
| Normal | `y` | Copy hash | Copy commit hash |
| Normal | `L` | Commit details | Show commit details |
| Normal | `zR` | Open all folds | Expand all folds |
| Normal | `zM` | Close all folds | Collapse all folds |

### Testing (Neotest)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>tt` | Run nearest test | Run test under cursor |
| Normal | `<leader>tf` | Run file tests | Run all tests in file |
| Normal | `<leader>ts` | Toggle summary | Toggle test summary |
| Normal | `<leader>to` | Open output | Open test output panel |

### Debugging (nvim-dap)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>db` | Toggle breakpoint | Set/remove breakpoint |
| Normal | `<leader>dc` | Continue | Start/continue debugging |
| Normal | `<leader>ds` | Step over | Step over function |
| Normal | `<leader>di` | Step into | Step into function |
| Normal | `<leader>do` | Step out | Step out of function |
| Normal | `<leader>dr` | Open REPL | Open debug REPL |
| Normal | `<leader>du` | Toggle UI | Toggle DAP UI |

### Project Management (Harpoon)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>ha` | Add file | Add current file to harpoon |
| Normal | `<leader>hh` | Toggle menu | Open harpoon quick menu |
| Normal | `<leader>h1` | Go to file 1 | Jump to harpoon file 1 |
| Normal | `<leader>h2` | Go to file 2 | Jump to harpoon file 2 |
| Normal | `<leader>h3` | Go to file 3 | Jump to harpoon file 3 |
| Normal | `<leader>h4` | Go to file 4 | Jump to harpoon file 4 |

### Session Management (Persistence)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>qs` | Restore session | Restore session for CWD |
| Normal | `<leader>ql` | Restore last | Restore last session |
| Normal | `<leader>qd` | Don't save | Don't save current session |

### AI Assistance

#### Copilot
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Insert | `<leader><Tab>` | Accept suggestion | Accept Copilot suggestion |

#### Claude Code
| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| Normal | `<leader>cc` | Toggle Claude Code | Open/close Claude Code panel |

#### Amp Commands
| Command | Description |
|---------|-------------|
| `:AmpSend <message>` | Send a message to Amp |
| `:AmpSendBuffer` | Send current buffer contents to Amp |
| `:AmpPromptSelection` | Add selected text to Amp prompt (visual mode) |
| `:AmpPromptRef` | Add file reference to Amp prompt |

## Installed Plugins

### Core Framework
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **folke/lazy.nvim** | Modern plugin manager with lazy loading | `config/lazy.lua` |

### LSP & Completion
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **neovim/nvim-lspconfig** | Native LSP configuration | `plugins/lsp.lua` |
| **williamboman/mason.nvim** | LSP/DAP/linter/formatter installer | `plugins/mason.lua` |
| **williamboman/mason-lspconfig.nvim** | Mason + lspconfig integration | `plugins/mason-lspconfig.lua` |
| **hrsh7th/nvim-cmp** | Completion engine | `plugins/completion.lua` |
| **hrsh7th/cmp-nvim-lsp** | LSP completion source | `plugins/completion.lua` |
| **hrsh7th/cmp-buffer** | Buffer completion source | `plugins/completion.lua` |
| **hrsh7th/cmp-path** | Path completion source | `plugins/completion.lua` |
| **hrsh7th/cmp-cmdline** | Command line completion | `plugins/completion.lua` |
| **L3MON4D3/LuaSnip** | Snippet engine | `plugins/completion.lua` |
| **saadparwaiz1/cmp_luasnip** | Snippet completion source | `plugins/completion.lua` |
| **b0o/schemastore.nvim** | JSON schemas for LSP | `plugins/schemastore.lua` |

### Syntax & Treesitter
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **nvim-treesitter/nvim-treesitter** | Advanced syntax highlighting | `plugins/treesitter.lua` |
| **nvim-treesitter/nvim-treesitter-context** | Show code context | `plugins/treesitter-context.lua` |
| **folke/ts-comments.nvim** | Better comment highlighting | `plugins/ts-comments.lua` |

### Git Integration
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **lewis6991/gitsigns.nvim** | Git decorations and hunks | `plugins/gitsigns.lua` |
| **tpope/vim-fugitive** | Git wrapper | `plugins/vim-fugitive.lua` |
| **tpope/vim-rhubarb** | GitHub integration for fugitive | `plugins/vim-rhubarb.lua` |
| **sindrets/diffview.nvim** | Advanced diff viewer | `plugins/diffview.lua` |
| **kdheepak/lazygit.nvim** | LazyGit integration | `plugins/lazygit.lua` |

### File Navigation
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **nvim-tree/nvim-tree.lua** | File explorer | `plugins/nvim-tree.lua` |
| **nvim-telescope/telescope.nvim** | Fuzzy finder | `plugins/telescope.lua` |
| **nvim-telescope/telescope-fzf-native.nvim** | FZF sorter for telescope | `plugins/telescope-fzf.lua` |
| **ThePrimeagen/harpoon** | Quick file navigation | `plugins/harpoon.lua` |
| **ahmedkhalf/project.nvim** | Project management | `plugins/project.lua` |

### Testing & Debugging
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **nvim-neotest/neotest** | Testing framework | `plugins/neotest.lua` |
| **nvim-neotest/neotest-go** | Go test adapter | `plugins/neotest.lua` |
| **nvim-neotest/neotest-jest** | Jest test adapter | `plugins/neotest.lua` |
| **olimorris/neotest-rspec** | RSpec test adapter | `plugins/neotest.lua` |
| **mfussenegger/nvim-dap** | Debug adapter protocol | `plugins/dap.lua` |
| **rcarriga/nvim-dap-ui** | DAP UI | `plugins/dap.lua` |
| **theHamsta/nvim-dap-virtual-text** | Virtual text for DAP | `plugins/dap.lua` |
| **nvim-neotest/nvim-nio** | Async I/O for neotest | `plugins/neotest.lua` |

### Code Quality
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **stevearc/conform.nvim** | Async formatter | `plugins/conform.lua` |
| **mfussenegger/nvim-lint** | Async linter | `plugins/lint.lua` |

### UI Enhancement
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **nvim-lualine/lualine.nvim** | Statusline | `plugins/lualine.lua` |
| **folke/noice.nvim** | Command line UI | `plugins/noice.lua` |
| **rcarriga/nvim-notify** | Notification manager | `plugins/notify.lua` |
| **stevearc/dressing.nvim** | Better UI for inputs | `plugins/dressing.lua` |
| **folke/which-key.nvim** | Keybinding helper | `plugins/which-key.lua` |
| **j-hui/fidget.nvim** | LSP progress UI | `plugins/fidget.lua` |

### Navigation & Movement
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **folke/flash.nvim** | Enhanced navigation | `plugins/flash.lua` |
| **folke/trouble.nvim** | Diagnostic list | `plugins/trouble.lua` |
| **folke/todo-comments.nvim** | TODO highlighting | `plugins/todo-comments.lua` |

### Editor Enhancement
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **echasnovski/mini.pairs** | Auto pairs | `plugins/mini-pairs.lua` |
| **echasnovski/mini.ai** | Better text objects | `plugins/mini-ai.lua` |
| **echasnovski/mini.bufremove** | Better buffer delete | `plugins/mini-bufremove.lua` |
| **echasnovski/mini.indentscope** | Indent scope highlighting | `plugins/mini-indentscope.lua` |
| **kylechui/nvim-surround** | Surround text objects | `plugins/nvim-surround.lua` |
| **numToStr/Comment.nvim** | Easy commenting | `plugins/comment.lua` |
| **tpope/vim-sleuth** | Auto-detect indentation | `plugins/vim-sleuth.lua` |
| **lukas-reineke/indent-blankline.nvim** | Indent guides | `plugins/indent.lua` |
| **kevinhwang91/nvim-bqf** | Better quickfix | `plugins/bqf.lua` |

### Session & Project
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **folke/persistence.nvim** | Session management | `plugins/persistence.lua` |

### Language-Specific
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **tpope/vim-rails** | Ruby on Rails support | `plugins/vim-rails.lua` |
| **tpope/vim-bundler** | Bundler integration | `plugins/vim-bundler.lua` |
| **vim-ruby/vim-ruby** | Ruby language support | `plugins/vim-ruby.lua` |
| **hashivim/vim-terraform** | Terraform support | `plugins/vim-terraform.lua` |
| **towolf/vim-helm** | Helm chart support | `plugins/vim-helm.lua` |
| **MTDL9/vim-log-highlighting** | Log file highlighting | `plugins/vim-log-highlighting.lua` |
| **andreshazard/vim-logreview** | Log review support | - |
| **chr4/nginx.vim** | Nginx syntax | - |
| **ekalinin/Dockerfile.vim** | Dockerfile support | `plugins/dockerfile.lua` |
| **cespare/vim-toml** | TOML support | `plugins/vim-toml.lua` |

### AI & Code Assistance
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **github/copilot.vim** | GitHub Copilot | `plugins/copilot.lua` |
| **sourcegraph/amp.nvim** | Amp AI coding assistant | `plugins/amp.lua` |
| **Exafunction/codeium.vim** | Claude Code integration | `plugins/claude-code.lua` |

### Colorscheme
| Plugin | Description | Config File |
|--------|-------------|-------------|
| **Shatur/neovim-ayu** | Ayu colorscheme | `plugins/ayu.lua` |

### Dependencies
| Plugin | Description |
|--------|-------------|
| **nvim-lua/plenary.nvim** | Lua utility functions |
| **nvim-tree/nvim-web-devicons** | File icons |
| **MunifTanjim/nui.nvim** | UI components |

## Installation

### Prerequisites

- **Neovim** >= 0.9.0
- **Git**
- **Node.js** >= 18.17.0 (for Amp and some LSP servers)
- **Ripgrep** (for Telescope live_grep)
- **A Nerd Font** (for icons)

### Installation Steps

1. **Backup existing configuration**:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. **Clone this configuration**:
```bash
git clone <your-repo-url> ~/.config/nvim
```

3. **Start Neovim**:
```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch.

4. **Check health**:
```vim
:checkhealth
:checkhealth amp
```

### Optional External Tools

#### Linters
Most linters are optional and will be used if available:

```bash
# JavaScript/TypeScript
npm install -g eslint_d

# Python
pip install flake8

# Ruby
gem install rubocop

# Go
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Shell scripts
brew install shellcheck

# YAML
pip install yamllint

# Docker
brew install hadolint

# Terraform
brew install tflint

# Ansible
pip install ansible-lint
```

#### Formatters
Most formatters are automatically installed via Mason when opening relevant files.

#### Debuggers
```bash
# Ruby
gem install debug

# Go
go install github.com/go-delve/delve/cmd/dlv@latest

# Node.js (installed via Mason)
```

#### AI Tools
```bash
# Amp CLI (for amp.nvim)
# Visit https://ampcode.com for installation instructions

# After installing Amp, run:
amp --ide
```

## Customization

### Adding New Plugins

1. Create a new file in `lua/plugins/`:
```bash
touch lua/plugins/my-plugin.lua
```

2. Add plugin specification:
```lua
return {
  "author/plugin-name",
  dependencies = { "dependency1", "dependency2" },
  event = "VeryLazy", -- or cmd, ft, keys for lazy loading
  config = function()
    require("plugin-name").setup({
      -- configuration here
    })
  end,
}
```

3. Add keybindings to `lua/config/keymaps.lua`:
```lua
keymap.set("n", "<leader>key", ":Command<CR>", { desc = "Description" })
```

### Modifying Keybindings

All global keybindings are centralized in `lua/config/keymaps.lua`:

```lua
local keymap = vim.keymap
local opts = { silent = true }

keymap.set("n", "<your-key>", "<your-command>", opts)
```

Plugin-specific keybindings are in their respective plugin files.

### Changing Editor Options

Modify `lua/config/options.lua`:

```lua
local opt = vim.opt

opt.your_option = value
```

### Temporarily Disabling Plugins

```bash
# Disable a plugin
mv lua/plugins/plugin-name.lua lua/plugins/plugin-name.lua.disabled

# Re-enable
mv lua/plugins/plugin-name.lua.disabled lua/plugins/plugin-name.lua
```

### Language Server Configuration

Edit `lua/plugins/lsp.lua` to add or modify language servers:

```lua
local servers = {
  your_lsp = {
    -- LSP-specific settings
  },
}
```

Mason will automatically install the LSP when you open a relevant file.

## Troubleshooting

### Plugin Issues

1. **Update plugins**:
```vim
:Lazy sync
```

2. **Clear plugin cache**:
```bash
rm -rf ~/.local/share/nvim
```

3. **Reinstall plugins**:
```vim
:Lazy clean
:Lazy sync
```

### LSP Issues

1. **Check LSP status**:
```vim
:LspInfo
```

2. **Restart LSP**:
```vim
:LspRestart
```

3. **Check Mason**:
```vim
:Mason
```

### Performance Issues

1. **Check startup time**:
```bash
nvim --startuptime startup.log
```

2. **Profile plugins**:
```vim
:Lazy profile
```

### Amp Integration Issues

1. **Check Amp health**:
```vim
:checkhealth amp
```

2. **Verify Amp CLI is running**:
```bash
amp --ide
```

3. **Check Amp logs**:
The plugin logs are available in Neovim's messages.

### Common Problems

**Problem**: Treesitter highlighting not working
**Solution**:
```vim
:TSUpdate
```

**Problem**: Telescope not finding files
**Solution**: Install ripgrep: `brew install ripgrep`

**Problem**: Icons not showing
**Solution**: Install a Nerd Font and configure your terminal

**Problem**: Copilot not working
**Solution**: Run `:Copilot setup` and authenticate

## Additional Resources

- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Neovim LSP Guide](https://neovim.io/doc/user/lsp.html)
- [Telescope Documentation](https://github.com/nvim-telescope/telescope.nvim)
- [Amp Documentation](https://ampcode.com/manual)

## Philosophy

This configuration prioritizes:

- **Performance**: Fast startup with lazy loading, efficient plugin management
- **Developer Experience**: Comprehensive tooling for multiple languages and workflows
- **Modern Workflow**: Testing, debugging, and AI assistance built-in
- **Consistency**: Logical keybindings and predictable behavior
- **Flexibility**: Easy to extend and customize for different projects
- **Professional Quality**: Production-ready setup for serious development work

## Notes

- Configuration uses 2-space indentation
- Copilot integration with custom keybindings
- Disabled relative line numbers (personal preference)
- Custom buffer navigation shortcuts
- Auto-format and lint on save
- Session persistence enabled
- All plugins are lazy-loaded for optimal performance
- LSP servers are auto-installed via Mason
- Formatters and linters are configured but optional

---

**Last Updated**: 2025-10-18
