-- Function to set Python provider dynamically

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
  local function detect_virtual_env()
    local venv_paths = {
      cwd .. "/.venv/bin/python",         -- Unix-style virtual environment
      cwd .. "/.venv/Scripts/python.exe", -- Windows-style virtual environment
    }
    for _, path in ipairs(venv_paths) do
      if set_python_path(path) then
        return true
      end
    end

    -- Detect venv-like folders dynamically
    local dirs = vim.fn.glob(cwd .. "/*", true, true) -- List all entries in the current directory
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

  -- Check for Python project markers
  local function is_python_project()
    local project_markers = { "requirements.txt", "pyproject.toml", "setup.py", "Pipfile" }
    for _, marker in ipairs(project_markers) do
      if vim.loop.fs_stat(cwd .. "/" .. marker) then
        return true
      end
    end
    return detect_virtual_env() -- Check dynamically for any virtual environment
  end

  -- Try to set the Python provider
  if is_python_project() then
    if not detect_virtual_env() then
      local system_python = find_valid_system_python()
      if system_python then
        set_python_path(system_python)
      end
    end
    -- Show final Python provider asynchronously
    vim.schedule(function()
      vim.notify("Python provider: " .. (vim.g.python3_host_prog or "None"), vim.log.levels.INFO)
    end)
  end
end

set_python_host_prog()
