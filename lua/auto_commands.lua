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
