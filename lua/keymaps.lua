-- Keymapping Helper
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Telescope Keybindings
map("n", "<C-p>", ":Telescope find_files<CR>")
map("n", "<C-f>", ":Telescope live_grep<CR>")
map("n", "<leader>fb", ":Telescope buffers<CR>")
map("n", "<leader>fh", ":Telescope help_tags<CR>")

-- Nvim-Tree Keybindings
map("n", "<leader>e", ":NvimTreeToggle<CR>")
map("n", "<CR>", function() require("nvim-tree.api").node.open.edit() end, { desc = "nvim-tree: Open" })
map("n", "o", function() require("nvim-tree.api").node.open.edit() end, { desc = "nvim-tree: Open" })
map("n", "<2-LeftMouse>", function() require("nvim-tree.api").node.open.edit() end, { desc = "nvim-tree: Open" })
map("n", "<BS>", function() require("nvim-tree.api").node.navigate.parent_close() end, { desc = "nvim-tree: Close Directory" })
map("n", "q", function() require("nvim-tree.api").tree.close() end, { desc = "nvim-tree: Close" })

-- Diagnostic Keybindings
map("n", "<space>q", vim.diagnostic.setloclist)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<space>f", vim.diagnostic.open_float)

-- Terminal Keybindings
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>")
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical size=50<CR>")
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>")
