-- Global Settings
local opt = vim.opt

opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true     -- Highlight current line
opt.expandtab = true      -- Use spaces instead of tabs
opt.tabstop = 4           -- Number of spaces a tab counts for
opt.softtabstop = 4       -- Number of spaces to insert/delete when editing
opt.shiftwidth = 4        -- Number of spaces for each indent
opt.smartindent = true    -- Smart autoindenting
opt.wrap = false          -- Disable line wrapping
opt.swapfile = false      -- Disable swap files
opt.backup = false        -- Disable backup files

-- Undo and Search Config
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
opt.undodir = home .. "/.vim/undodir"
opt.undofile = true
opt.incsearch = true

-- Appearance and Usability
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.updatetime = 50
opt.colorcolumn = "120"
opt.synmaxcol = 2000

-- Diagnostics Configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
