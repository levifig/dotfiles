# Changelog

All notable changes to this Neovim configuration will be documented in this file.

## [v2.0.1] - 2025-07-09

### Added
- **Claude Code Integration**: Added claude-code.nvim plugin for seamless integration with Claude Code AI assistant
  - Terminal window integration with customizable position and size
  - Automatic file change detection and reloading
  - Git project root detection
  - Command variants for continue, resume, and verbose modes
  - Keymaps: `<C-,>` (toggle), `<leader>cC` (continue), `<leader>cV` (verbose)

## [v2.0.0] - 2025-07-01

### Changed
- **Complete Plugin Consolidation**: Restructured all plugins into self-contained files in `lua/plugins/` directory
- **One File Per Plugin**: Each plugin now has a single file containing both specification and configuration
- **Simplified Plugin Management**: Removed redundant `plugins.lua` file - Lazy.nvim now loads directly from `plugins/` directory
- **Improved Plugin Structure**: All plugin files now return proper Lazy.nvim specifications with embedded configurations

### Fixed
- **LSP Loading Error**: Resolved "lspconfig not found" error by converting LSP configuration to proper plugin spec
- **Dependency Issues**: Fixed "module 'nui.object' not found" error by properly specifying noice.nvim dependencies
- **Plugin Loading Order**: Eliminated all plugin loading errors by ensuring proper dependency declarations
- **Configuration Structure**: Converted all remaining configuration files to proper plugin specifications

### Added
- **Easy Plugin Management**: Plugins can now be disabled by renaming files (e.g., `plugin.lua` → `plugin.lua.disabled`)
- **Self-Contained Architecture**: Each plugin file contains everything needed for that plugin
- **Better Error Handling**: Improved plugin loading with proper error checking and fallbacks

### Removed
- Redundant `plugins.lua` file (functionality moved to individual plugin files)
- Separate configuration files that duplicated plugin specifications
- Complex plugin loading structure in favor of simpler self-contained approach

---

## [v1.3] - 2025-06-30

### Changed
- **Plugin Configuration Restructure**: Simplified plugin management by consolidating plugin list and configurations into a single `plugins.lua` file
- **Keybind Organization**: Moved all plugin keybinds from plugin definitions to centralized `config/keymaps.lua` for better maintainability
- **NvimTree Configuration**: Fixed NvimTree loading issues by removing lazy loading and disabling problematic diagnostics

### Fixed
- **NvimTree Commands**: Resolved `NvimTreeToggle` command availability by removing `cmd` lazy loading
- **Treesitter Context**: Added missing `nvim-treesitter-context` plugin dependency
- **Plugin Loading**: Eliminated circular dependency issues between plugin specs and keybind definitions
- **Autocmd Formatting**: Fixed `will_fallback_lsp` error by updating conform.nvim API usage to `lsp_fallback = true`

### Removed
- Separate `plugin-list.lua` file (merged into `plugins.lua`)
- Redundant keybind definitions in plugin specifications
- NvimTree diagnostics (causing sign placement errors)

---

## [v1.1] - 2025-06-30

### Major Enhancements
- **Performance Optimization**: Added comprehensive lazy loading for faster startup times
- **Testing Integration**: Added neotest with RSpec, Jest, and Go test adapters
- **Debugging Support**: Full nvim-dap setup with Ruby, Go, JavaScript, TypeScript, and Python support
- **Modern Git Workflow**: Added diffview.nvim and LazyGit integration
- **Project Management**: Added project.nvim and Harpoon for better navigation
- **DevOps Enhancements**: Enhanced Terraform, Ansible, and Kubernetes tooling

### Added
- **Testing Framework**: 
  - neotest with language-specific adapters
  - Test keymaps: `<leader>tt`, `<leader>tf`, `<leader>ts`, `<leader>to`
- **Debugging Capabilities**:
  - nvim-dap with DAP UI and virtual text
  - Debug keymaps: `<leader>db`, `<leader>dc`, `<leader>ds`, `<leader>di`, `<leader>do`, `<leader>du`
  - Language adapters for Ruby, Go, JavaScript/TypeScript, Python
- **Git Workflow Tools**:
  - diffview.nvim for advanced diff viewing and merge conflict resolution
  - LazyGit integration with `<leader>gg` keymap
  - Enhanced gitsigns configuration
- **Project Management**:
  - project.nvim for automatic project detection
  - Harpoon for quick file bookmarking (`<leader>ha`, `<leader>hh`, `<leader>h1-4`)
  - Telescope projects integration (`<leader>fp`)
- **Code Quality**:
  - Auto-format on save with conform.nvim
  - Auto-lint with nvim-lint
  - Manual triggers: `<leader>f` (format), `<leader>l` (lint)
- **Enhanced LSP Support**:
  - Added Helm language server
  - Enhanced Terraform and Ansible configurations
  - Better DevOps tooling support

### Changed
- **Plugin Loading**: Converted most plugins to lazy loading with proper events, commands, and keymaps
- **Rails Development**: Enhanced vim-rails with vim-bundler integration
- **Treesitter**: Added build command and proper event loading
- **Completion**: Added InsertEnter event for better performance
- **File Explorer**: Added command and key-based loading for nvim-tree
- **Telescope**: Enhanced with projects extension and better lazy loading

### Performance Improvements
- Plugins now load only when needed (file types, commands, keymaps)
- Faster startup time through comprehensive lazy loading
- Event-driven plugin initialization
- Reduced initial load overhead

---

## [v1.2] - 2025-06-30

### Major Changes
- **Back to Minimal Setup**: Migrated from LazyVim-based configuration back to a minimal, custom lazy.nvim setup
- **Improved Plugin Organization**: Restructured plugins with clear categorization and dependency documentation
- **Preserved Custom Preferences**: Maintained comma as leader key and all custom keymaps while removing LazyVim overhead

### Added
- New `plugins.lua` file with categorized plugin list and dependency documentation
- Individual plugin configuration files under `lua/plugins/` directory
- Comprehensive commented section with LazyVim features for future reference
- Better autocmds for common editor behaviors (highlight on yank, resize splits, etc.)

### Changed
- **File Structure**:
  ```
  lua/
  ├── plugins.lua          # Simple, categorized plugin list
  ├── plugins/             # Individual plugin configs
  │   ├── colorscheme.lua  # Ayu mirage theme
  │   ├── lsp.lua          # LSP configuration
  │   ├── telescope.lua    # Fuzzy finder
  │   ├── completion.lua   # nvim-cmp setup
  │   ├── treesitter.lua   # Syntax highlighting
  │   ├── gitsigns.lua     # Git integration
  │   └── ...              # Other plugin configs
  └── config/              # Core configuration
      ├── autocmds.lua     # Custom autocmds
      ├── keymaps.lua      # Custom keymaps (comma leader)
      ├── lazy.lua         # Direct lazy.nvim setup
      └── options.lua      # Editor options
  ```
- Removed LazyVim dependency and all its overhead
- Converted to direct lazy.nvim plugin management
- Organized plugins by category (Colorscheme, UI, LSP, Git, etc.)
- Added dependency documentation for each plugin category

### Removed
- LazyVim framework and all its automatic configurations
- Snacks.nvim and related LazyVim-specific plugins
- Plugin loading conflicts and buffer management issues

### Fixed
- Eliminated snacks.nvim buffer errors
- Resolved plugin loading order issues
- Simplified configuration while maintaining functionality

---

## [v1.0] - 2025-06-30

### Major Changes
- **LazyVim Integration**: Migrated from standalone lazy.nvim setup to LazyVim-based configuration
- **File Structure Reorganization**: Moved from `lua/core/` to `lua/config/` following LazyVim conventions
- **Fixed Treesitter Configuration**: Resolved missing treesitter config call that was causing setup issues

### Added
- LazyVim as base configuration with all its built-in features
- Dashboard with custom ASCII logo and quick actions
- Enhanced UI components:
  - Better notifications (nvim-notify)
  - Improved input dialogs (dressing.nvim)
  - Noicer command line and messages (noice.nvim)
- Buffer management improvements:
  - Enhanced bufferline with diagnostics integration
  - Better buffer removal (mini.bufremove)
  - Buffer navigation keymaps
- Smooth scrolling (neoscroll.nvim)
- Better quickfix window (nvim-bqf)
- Enhanced indent guides (mini.indentscope)

### Changed
- **File Structure**:
  ```
  lua/
  ├── config/           # LazyVim configuration (new)
  │   ├── autocmds.lua
  │   ├── keymaps.lua
  │   ├── lazy.lua
  │   └── options.lua
  └── plugins/          # Plugin definitions (restructured)
      ├── init.lua      # Core plugins
      ├── extras.lua    # Additional enhancements
      └── ui.lua        # UI-focused plugins
  ```
- Converted plugin definitions to LazyVim-compatible format
- Updated `init.lua` to bootstrap LazyVim properly
- Preserved all custom keymaps and options while integrating with LazyVim defaults

### Fixed
- Treesitter configuration now properly loads and initializes
- Plugin loading order and dependencies resolved
- Configuration structure now follows modern Neovim best practices

---

## [v0.1] - Previous State

### Original Configuration
The initial configuration was a custom lazy.nvim setup with the following structure:

```
lua/
├── core/
│   ├── init.lua
│   ├── options.lua
│   ├── keymaps.lua
│   └── disable_builtins.lua
└── plugins/
    ├── init.lua
    └── config/
        ├── ayu.lua
        ├── blankline.lua
        ├── cmp.lua
        ├── comment.lua
        ├── copilot.lua
        ├── gitsigns.lua
        ├── lspconfig.lua
        ├── lualine.lua
        ├── mason.lua
        ├── neodev.lua
        ├── nvim_tree.lua
        ├── telescope.lua
        ├── treesitter.lua
        └── wakatime.lua
```

### Features Included
- Custom keymaps with comma as leader key
- Ayu colorscheme
- LSP configuration with Mason
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- nvim-tree for file exploration
- Completion with nvim-cmp
- Git integration with gitsigns and fugitive
- GitHub Copilot integration
- Custom options and UI preferences

### Known Issues
- Treesitter configuration was defined but not properly loaded
- Plugin structure didn't follow modern LazyVim patterns
- Missing many quality-of-life improvements available in LazyVim