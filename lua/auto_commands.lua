-- Auto commands


-- Check if Treesitter parser is available for the filetype

vim.api.nvim_create_autocmd('FileType', {
  pattern = { "python", "lua" }, -- Restrict to Python and Lua files
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
    vim.opt.relativenumber = true -- Enable relative numbers in normal mode
    vim.opt.number = true         -- Keep absolute numbers
  end,
})


local python_provider = require("python_provider")

-- Set up Python provider dynamically based on project type or file type
vim.api.nvim_create_autocmd({ "VimEnter", "BufReadPre" }, {
  pattern = { "*.py", "*" }, -- Trigger for Python files and directories
  callback = function()
    local cwd = vim.fn.getcwd()
    local files = vim.fn.glob(cwd .. "/*", true, true)
    -- Check if the directory contains Python project indicators or files
    local is_python_project = false
    for _, file in ipairs(files) do
      if file:match("%.py$") or file:match("requirements%.txt$") or file:match("pyproject%.toml$") or file:match("setup%.py$") or file:match("Pipfile$") then
        is_python_project = true
        break
      end
    end
    -- If any Python files or indicators are found, set the Python host program
    if is_python_project or vim.fn.expand("%:e") == "py" then
      python_provider.set_python_host_prog()
    end
  end,
})
