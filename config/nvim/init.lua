-- Suppress deprecation warnings for now
vim.deprecate = function() end

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim and load plugins
require("config.lazy")
