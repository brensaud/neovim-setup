# **Neovim-Setup**

This repository contains a fully customizable and dynamic **Neovim** setup designed for developers, with a particular focus on **Lua programming** and dynamic Python provider management.

---

## **Overview**
This setup offers:
1. **Dynamic Python Provider Management**:
   - Automatically detects Python environments (system or virtual) and sets the Python provider.
2. **Project-Specific Configuration**:
   - Autocommands manage plugins and settings based on project files (e.g., `*.py` files, `requirements.txt`).
3. **Lazy.nvim Plugin Management**:
   - Uses `lazy.nvim` for efficient plugin management.
4. **Development-Friendly Enhancements**:
   - `.vscode/settings.json` to improve coding in Lua.
   - Simplified configurations split into `init.lua` and custom modules.

---

## **Features**
1. **Dynamic Python Detection**:
   - Automatically detects `.venv` or other virtual environments and sets the Python provider.
   - Supports projects with indicators like `requirements.txt`, `setup.py`, or `pyproject.toml`.

2. **Modular Configuration**:
   - Clean separation of logic in:
     - `init.lua` for base configuration.
     - `lua/python_provider.lua` for Python-specific settings.

3. **Plugins**:
   - Plugin management handled with `lazy.nvim` and `lazy-lock.json` to ensure stability.

4. **VSCode Compatibility**:
   - Adds `.vscode/settings.json` for seamless integration when editing Lua files.

---

## **File Structure**

```plaintext
.
├── .vscode/            # VSCode settings for Lua programming
├── lua/                # Lua modules for custom configurations
│   └── python_provider.lua   # Python provider setup
├── init.lua            # Main configuration file
├── lazy-lock.json      # Plugin lock file for lazy.nvim
├── .gitignore          # Ignores unnecessary files
└── README.md           # Documentation (You're reading it now!)
```

---

## **Setup Instructions**

### Prerequisites:
- **Neovim** v0.10.2+ (latest version recommended)
- Python (3.x)
- A package manager for Neovim plugins like `lazy.nvim`.

### Steps:
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/neovim-setup.git ~/.config/nvim
   ```

2. **Install Plugins**:
   Open Neovim and run:
   ```vim
   :Lazy sync
   ```

3. **Verify Python Provider**:
   - Open a Python project or file and check the provider:
     ```vim
     :checkhealth
     ```

---

## **Key Modules**

### Python Provider (`lua/python_provider.lua`)
- Detects virtual environments:
  - `.venv/bin/python` for Unix/Linux.
  - `.venv/Scripts/python.exe` for Windows.
- Falls back to system Python if no virtual environment is found.

### Autocommand for Python (`init.lua`)
- Automatically triggers Python provider setup when:
  - Opening a `.py` file.
  - Entering a directory with Python indicators.

---

## **Contributing**
Feel free to contribute to improve this Neovim setup:
1. Fork the repository.
2. Make your changes.
3. Submit a pull request.

---

## **License**
This project is licensed under the **MIT License**.

---

## **Acknowledgments**
- **Neovim** for a powerful, extensible editor.
- **Lazy.nvim** for efficient plugin management.
