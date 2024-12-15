-- Dynamic Python Provider Setup
local function set_python_host_prog()
  local cwd = vim.fn.getcwd() -- Get the current working directory

  -- Helper function to check and set the Python path
  local function set_python_path(path)
    if vim.loop.fs_stat(path) then
      vim.g.python3_host_prog = path
      return true
    end
    return false
  end

  -- Search for a valid system Python, excluding mingw/msys
  local function find_valid_system_python()
    local python_executables = { "python3", "python" }
    for _, exe in ipairs(python_executables) do
      local python_path = vim.fn.exepath(exe)
      if python_path and not python_path:match("mingw") and not python_path:match("msys") then
        return python_path
      end
    end
    return nil
  end

  -- Check for virtual environments in the project directory
  local function check_project_venv()
    local venv_paths = {
      cwd .. "/.venv/bin/python",    -- Unix-style virtual environment
      cwd .. "/.venv/Scripts/python.exe", -- Windows-style virtual environment
    }
    for _, path in ipairs(venv_paths) do
      if set_python_path(path) then
        return true
      end
    end

    -- Detect venv-like folders dynamically
    local dirs = vim.fn.glob(cwd .. "/*", true, true)
    for _, dir in ipairs(dirs) do
      if vim.loop.fs_stat(dir) and vim.loop.fs_stat(dir).type == "directory" then
        local python_path
        if vim.loop.os_uname().sysname == "Windows_NT" then
          python_path = dir .. "/Scripts/python.exe"
        else
          python_path = dir .. "/bin/python"
        end
        if set_python_path(python_path) then
          return true
        end
      end
    end
    return false
  end

  -- Try to set the Python provider
  if not check_project_venv() then
    local system_python = find_valid_system_python()
    if system_python then
      set_python_path(system_python)
    end
  end
end

set_python_host_prog()

vim.schedule(function()
  vim.notify("Python provider: " .. (vim.g.python3_host_prog or "None"), vim.log.levels.INFO)
end)
