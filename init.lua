-- 1. Leader Key Setup (Set early to ensure consistent behavior for all keymaps)
vim.g.mapleader = " "      -- Space key as leader
vim.g.maplocalleader = " " -- Space key as local leader

-- 2. Load Settings (Global options and configurations)
require("settings")

-- 3. Load Plugins (Plugins must load early for dependencies to work)
require("plugins")

-- 4. Load Keymaps (Keymaps after plugins to avoid conflicts with plugin defaults)
require("keymaps")

-- 6. Load LSP Setup (Language server configurations; depends on plugins being loaded)
require("lspsetup")

-- 7. nvim-cmp Setup (Autocompletion; depends on LSP and plugins)
require("nvimcmp")

-- 8. Auto commands (Event-driven commands; load last to avoid conflicts)
require("auto_commands")
