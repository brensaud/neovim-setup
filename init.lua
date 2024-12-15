-- Leader key setup
vim.g.mapleader = " " -- Space key as leader
vim.g.maplocalleader = " " -- Space key as local leader

-- Load Settings
require("settings")

-- Load Plugins
require("plugins")

-- Load Keymaps
require("keymaps")

-- Load LSP Setup (Lua Language Server Fix)
require("lspsetup")

-- nvim-cmp Setup
require("nvimcmp")

-- Auto commands
require("auto_commands")
