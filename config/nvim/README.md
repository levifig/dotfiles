# Personal Neovim Configuration

A personal Neovim configuration built with lazy.nvim, customized for my development workflow and preferences.

## Overview

This configuration is built with lazy.nvim and heavily customized with personal preferences for keybindings, plugins, and editor behavior. It focuses on a clean, efficient development environment with modern tooling and centralized configuration management.

## Structure

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
│       ├── ayu.lua         # Colorscheme plugin with config
│       ├── telescope.lua   # Fuzzy finder plugin with config
│       ├── lsp.lua         # LSP plugin with config
│       ├── completion.lua  # Completion plugin with config
│       └── ...             # Other plugins (one file per plugin)
└── lazy-lock.json          # Plugin version lock file
```

## Key Features

### Editor Configuration
- **Leader key**: `,` (comma)
- **Tab settings**: 2 spaces, smart indentation
- **Line numbers**: Enabled (no relative numbers)
- **Search**: Case-insensitive with smart case
- **Clipboard**: System clipboard integration
- **No swap files**: Undo file enabled for persistence

### Custom Keybindings

#### Core Navigation
| Mode | Key | Action |
|------|-----|--------|
| Insert | `jk` | Escape to normal mode |
| Normal | `<leader><space>` | Clear search highlights |
| Normal | `<leader>e` | Toggle file explorer |
| Normal | `<leader><leader>` | Find files (Telescope) |
| Normal | `<leader>fg` | Live grep (Telescope) |
| Normal | `<leader>fb` | Buffer search (Telescope) |
| Normal | `<C-x>` | Close buffer |
| Normal | `bn/bl` | Next buffer |
| Normal | `bv/bh` | Previous buffer |
| Normal | `<C-]>/<C-[>` | Navigate buffers |
| Normal | `<Alt>+arrows` | Resize splits |

#### Testing & Debugging
| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>tt` | Run nearest test | Neotest |
| `<leader>tf` | Run current file tests | Neotest |
| `<leader>ts` | Toggle test summary | Neotest |
| `<leader>to` | Open test output | Neotest |
| `<leader>db` | Toggle breakpoint | nvim-dap |
| `<leader>dc` | Continue debugging | nvim-dap |
| `<leader>ds` | Step over | nvim-dap |
| `<leader>di` | Step into | nvim-dap |
| `<leader>do` | Step out | nvim-dap |
| `<leader>du` | Toggle DAP UI | nvim-dap |

#### Git Workflow
| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>gg` | Open LazyGit | LazyGit |
| `<leader>gd` | Open diff view | Diffview |
| `<leader>gh` | File history | Diffview |

#### Project Management
| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>fp` | Find projects | Telescope + Project.nvim |
| `<leader>ha` | Add file to harpoon | Harpoon |
| `<leader>hh` | Toggle harpoon menu | Harpoon |
| `<leader>h1-4` | Go to harpoon file 1-4 | Harpoon |

#### Code Quality
| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>f` | Format buffer | Conform |
| `<leader>l` | Trigger linting | nvim-lint |

#### Session Management
| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>qs` | Restore session | Persistence |
| `<leader>ql` | Restore last session | Persistence |
| `<leader>qd` | Don't save current session | Persistence |

### Plugin Ecosystem

#### Core Development
- **File Management**: nvim-tree, telescope, harpoon
- **LSP & Completion**: Native LSP, mason, nvim-cmp
- **Code Intelligence**: treesitter, copilot
- **Project Management**: project.nvim, persistence

#### Testing & Debugging
- **Testing**: neotest (RSpec, Jest, Go support)
- **Debugging**: nvim-dap with Ruby/Go/JS/Python adapters
- **Code Quality**: conform.nvim, nvim-lint

#### Git Workflow
- **Git Integration**: gitsigns, vim-fugitive, diffview.nvim
- **Git UI**: LazyGit integration

#### Language Support
- **Ruby/Rails**: vim-rails, vim-bundler, ruby_lsp
- **Go**: gopls, delve debugger
- **JavaScript/TypeScript**: ts_ls, Jest testing
- **DevOps**: Terraform, Ansible, Kubernetes, Docker

#### UI & Experience
- **UI Enhancements**: lualine, noice, notify, dressing
- **Navigation**: flash, trouble, todo-comments, which-key

## Configuration

### Adding New Plugins

1. Create a new plugin file in `lua/plugins/plugin-name.lua`:

```lua
return {
  "author/plugin-name",
  dependencies = { "dependency1", "dependency2" },
  config = function()
    require("plugin-name").setup({
      -- Plugin configuration here
    })
  end,
}
```

2. Add any keybinds to `lua/config/keymaps.lua`:

```lua
keymap.set("n", "<leader>key", ":PluginCommand<CR>", { desc = "Description" })
```

### Disabling Plugins

To disable a plugin temporarily:

```bash
mv lua/plugins/plugin-name.lua lua/plugins/plugin-name.lua.disabled
```

To re-enable:

```bash
mv lua/plugins/plugin-name.lua.disabled lua/plugins/plugin-name.lua
```

### Modifying Keybindings

Edit `lua/config/keymaps.lua`:

```lua
local keymap = vim.keymap
local opts = { silent = true }

keymap.set("n", "<your-key>", "<your-command>", opts)
```

### Changing Editor Options

Modify `lua/config/options.lua`:

```lua
local opt = vim.opt

opt.your_option = value
```

### Plugin-Specific Configuration

Each plugin is self-contained in its own file in `lua/plugins/`. Each file contains both the plugin specification and its configuration. Key files:

- **LSP**: `lua/plugins/lsp.lua` - Language server setup with Mason integration
- **Telescope**: `lua/plugins/telescope.lua` - Fuzzy finder with all settings
- **Treesitter**: `lua/plugins/treesitter.lua` - Syntax highlighting configuration
- **Copilot**: `lua/plugins/copilot.lua` - AI assistance with custom settings
- **Colorscheme**: `lua/plugins/ayu.lua` - Ayu theme with mirage variant
- **Completion**: `lua/plugins/completion.lua` - nvim-cmp with all sources

### Auto Commands

Custom auto commands are in `lua/config/autocmds.lua`. Add new ones:

```lua
vim.api.nvim_create_autocmd("Event", {
  pattern = "pattern",
  callback = function()
    -- Your logic
  end,
})
```

## Installation

1. Backup existing Neovim configuration
2. Clone this repository to `~/.config/nvim`
3. Start Neovim - plugins will auto-install via Lazy.nvim
4. Run `:checkhealth` to verify setup

### Optional External Tools

For full functionality, install these external tools:

#### Linters (optional - configuration will work without them)
```bash
# Lua
brew install luacheck

# JavaScript/TypeScript
npm install -g eslint_d

# Python
pip install flake8

# Ruby (if using Ruby projects)
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

#### Formatters (handled by Mason LSP installer)
Most formatters are automatically installed via Mason when you open relevant files.

#### Debuggers
- **Ruby**: `gem install debug`
- **Go**: `go install github.com/go-delve/delve/cmd/dlv@latest`
- **Node.js**: Install via Mason or `npm install -g node-debug2-adapter`

## Customization Philosophy

This configuration prioritizes:
- **Performance**: Fast startup with lazy loading, responsive editing
- **Developer Experience**: Comprehensive tooling for Rails, Go, and DevOps work
- **Modern Workflow**: Testing, debugging, and Git integration built-in
- **Consistency**: Logical keybindings and predictable behavior
- **Flexibility**: Easy to extend and customize for different projects

## Plugin Management

Uses [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management:
- **Self-contained plugins**: Each plugin file contains both specification and configuration
- **Easy management**: Disable plugins by renaming files (add `.disabled` extension)
- **Auto-installs missing plugins**: Lazy.nvim automatically installs new plugins
- **Lazy loading for performance**: Plugins load only when needed
- **Version locking**: `lazy-lock.json` ensures reproducible builds
- **Update checking enabled**: Automatic plugin update notifications

## Key Features

### Development Workflow
- **Multi-language support**: Ruby/Rails, Go, JavaScript/TypeScript, Python
- **DevOps tooling**: Terraform, Ansible, Kubernetes, Docker support
- **Testing integration**: Run tests directly from editor with visual feedback
- **Debugging**: Full debugging support with breakpoints and variable inspection
- **Auto-formatting**: Format on save with language-specific formatters
- **Linting**: Real-time code quality checks

### Performance Optimizations
- **Lazy loading**: Plugins load only when needed for fast startup
- **Event-driven**: Smart loading based on file types and commands
- **Minimal overhead**: Clean, efficient setup without bloat

### Modern Git Workflow
- **Visual diff viewer**: Advanced diff and merge conflict resolution
- **LazyGit integration**: Full-featured Git UI within Neovim
- **Project management**: Automatic project detection and switching

## Notes

- Minimal setup with maximum functionality
- Copilot integration with custom keybindings
- Disabled relative line numbers (personal preference)
- Custom buffer navigation shortcuts
- Optimized for 2-space indentation workflow
- Auto-format and lint on save