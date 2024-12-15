-- Auto commands


-- Set filetype to Python for .py files

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.py",
  command = "set filetype=python",
})



-- Check if Treesitter parser is available for the filetype

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    local parsers = require('nvim-treesitter.parsers')
    local lang = vim.bo.filetype
    if parsers.has_parser(lang) then
      print(lang .. " parser is available")
    else
      print("No parser found for " .. lang)
    end
  end
})



-- Autocmd to toggle relative numbers in normal mode and absolute numbers in insert mode
vim.api.nvim_create_augroup("ToggleRelativeNumber", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  group = "ToggleRelativeNumber",
  callback = function()
    vim.opt.relativenumber = false -- Disable relative numbers in insert mode
    vim.opt.number = true          -- Keep absolute numbers
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  group = "ToggleRelativeNumber",
  callback = function()
    vim.opt.relativenumber = true  -- Enable relative numbers in normal mode
    vim.opt.number = true          -- Keep absolute numbers
  end,
})


-- Autocommand to enable Python provider dynamically for Python files or projects
local set_python_host_prog = require("python_provider").set_python_host_prog

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  callback = function()
    local filetype = vim.bo.filetype
    local cwd = vim.fn.getcwd()
    if filetype == "python" or vim.fn.isdirectory(cwd .. "/.venv") == 1 or vim.loop.fs_stat(cwd .. "/requirements.txt") then
      set_python_host_prog()
    end
  end,
})