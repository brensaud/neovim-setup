-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Define Plugins
local plugins = {
  -- Treesitter for Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Ensure these languages are always installed
        ensure_installed = {
          "python", "lua", "javascript", "typescript",
          "bash", "vim", "markdown", "html", "css", "json"
        },
        -- Always sync install to ensure languages are ready
        sync_install = true,

        -- Enhanced highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(lang, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end,
        },

        -- Text objects for more advanced navigation
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })

      -- Use GCC from MSYS2 for Treesitter compilation
      require("nvim-treesitter.install").compilers = { "clang", "gcc" }
    end,
  },


  -- LSP and Mason Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "pyright", "lua_ls", "bashls",
          "jsonls", "html", "cssls"
        },
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Language Server Configurations
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            telemetry = { enable = false },
          },
        },
        capabilities = capabilities,
      })
    end,
  },



  -- Advanced Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },


  -- Kanagawa Colorscheme
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        keywordStyle = { bold = true },
        statementStyle = { bold = true },
        transparent = false,
        variablebuiltinStyle = { italic = true },
        specialReturn = true,    -- Special highlight for `return`
        specialException = true, -- Special highlight for exception handling keywords
        dimInactive = true,
        terminalColors = true,
        globalStatus = true, -- Set global status line
      })

      vim.cmd("colorscheme kanagawa-wave")
    end,
  },


  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,      -- Cycle input history
              ["<C-p>"] = actions.cycle_history_prev,      -- Cycle input history
              ["<C-j>"] = actions.move_selection_next,     -- Move to next selection
              ["<C-k>"] = actions.move_selection_previous, -- Move to previous selection
              ["<C-c>"] = actions.close,                   -- Close Telescope
              ["<CR>"] = actions.select_default,           -- Select default result
            },
            n = {
              ["q"] = actions.close, -- Close in normal mode
            },
          },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.6, -- Use 0.6 for better visibility
            },
          },
          sorting_strategy = "ascending",
          prompt_prefix = "🔍 ",
          selection_caret = "➤ ",
          winblend = 10,
        },
        pickers = {
          find_files = {
            hidden = true,      -- Include hidden files
            theme = "dropdown", -- Use dropdown theme
          },
          live_grep = {
            theme = "dropdown", -- Use dropdown theme
          },
          buffers = {
            theme = "dropdown", -- Use dropdown theme
            initial_mode = "normal",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- Enable fuzzy search
            override_generic_sorter = true, -- Override sorter for generic searches
            override_file_sorter = true,    -- Override sorter for file searches
          },
        },
      })

      -- Load the FZF extension for Telescope
      telescope.load_extension("fzf")
    end,
  },


  -- Tab Line
  { "romgrk/barbar.nvim", dependencies = "kyazdani42/nvim-web-devicons" },


  -- Formatting and Linting
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,   -- Python formatter
          null_ls.builtins.formatting.isort,   -- Python import sorter
          null_ls.builtins.diagnostics.flake8, -- Python linter
        },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "black", "flake8", "isort" },
        automatic_installation = true, -- Automatically install required tools
      })
    end,
  },


  -- Debugging
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.python = {
        type = "executable",
        command = vim.g.python3_host_prog or "python", -- Use Python from the provider or system Python
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}", -- Launch the current file
        },
      }
    end,
  },


  -- nvim-dap-ui with nvim-nio dependencies
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- Add nvim-nio as a dependency
    },
    config = function()
      require("dapui").setup()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Automatically open and close the DAP UI on debugging events
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },


  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "┃" },
          change       = { text = "┃" },
          delete       = { text = "┃" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" }
        },
      })

      -- Explicitly define GitSigns highlight groups to remove deprecation warnings
      vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })
      vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "DiffDelete" })
      vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "DiffChange" })
    end,
  },


  -- File Explorer (NvimTree)
  {
    "nvim-tree/nvim-tree.lua",                        -- Use the updated repository
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Updated dependency path
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,    -- Set the width of the tree view
          side = "left", -- Display the tree on the left side
        },
        filters = {
          dotfiles = false, -- Do not show dotfiles by default
        },
        renderer = {
          highlight_git = true,               -- Highlight git status in the tree
          highlight_opened_files = "all",     -- Highlight all opened files
          indent_markers = { enable = true }, -- Enable indent markers
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
            },
          },
        },
        git = {
          enable = true,  -- Enable git integration
          ignore = false, -- Show files ignored by git
        },
        actions = {
          open_file = {
            resize_window = true, -- Automatically resize tree view when opening a file
          },
        },
        diagnostics = {
          enable = true, -- Enable diagnostics in the tree
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
      })
    end,
  },


  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" }, -- Add icons for enhanced visuals
    config = function()
      require("lualine").setup({
        options = {
          theme = "kanagawa",        -- Kanagawa theme for lualine
          section_separators = "",   -- No separators for sections
          component_separators = "", -- No separators for components
          icons_enabled = true,      -- Enable icons
          globalstatus = true,       -- Use a global statusline for all splits
        },
        sections = {
          lualine_a = { "mode" },                               -- Show current mode (Normal, Insert, etc.)
          lualine_b = { "branch" },                             -- Show the current Git branch
          lualine_c = { { "filename", path = 1 } },             -- Show filename with relative path
          lualine_x = { "encoding", "fileformat", "filetype" }, -- Encoding, format, and type
          lualine_y = { "progress" },                           -- Show cursor progress
          lualine_z = { "location" },                           -- Show line and column location
        },
        inactive_sections = {                                   -- For inactive windows
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "nvim-tree", "quickfix", "fugitive" }, -- Add extensions for plugins
      })
    end,
  },


  -- Integrated Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*", -- Ensures compatibility with the latest version
    config = function()
      require("toggleterm").setup({
        size = 20,                -- Terminal height for horizontal mode
        open_mapping = [[<C-\>]], -- Keymap to toggle the terminal
        hide_numbers = true,      -- Hide line numbers in terminal buffers
        shade_filetypes = {},
        shade_terminals = true,   -- Add a slight shade to terminal background
        shading_factor = 2,       -- Shading intensity (1-3)
        start_in_insert = true,   -- Start terminal in insert mode
        insert_mappings = true,   -- Use the defined mapping in insert mode
        terminal_mappings = true, -- Enable terminal buffer mappings
        persist_size = true,      -- Remember terminal size
        direction = "horizontal", -- Terminal direction: horizontal, vertical, float, or tab
        close_on_exit = true,     -- Close terminal on process exit
        shell = vim.o.shell,      -- Use the default shell
        float_opts = {
          border = "curved",      -- Curved border for floating terminals
          winblend = 10,          -- Transparency level
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },


  -- vim-airline
  {
    "vim-airline/vim-airline",
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
    config = function()
      -- Enable powerline fonts
      vim.g.airline_powerline_fonts = 1

      -- Set the theme for vim-airline
      vim.g.airline_theme = "dark"

      -- Enable tabline extension to display tabs
      vim.g["airline#extensions#tabline#enabled"] = 1

      -- Use the default tabline formatter
      vim.g["airline#extensions#tabline#formatter"] = "default"

      -- Enable LSP integration for vim-airline
      vim.g["airline#extensions#nvimlsp#enabled"] = 1

      -- Optional: Additional settings for buffer handling and aesthetics
      vim.g["airline#extensions#whitespace#enabled"] = 1 -- Highlight trailing whitespace
      vim.g["airline#extensions#branch#enabled"] = 1     -- Show the current Git branch
      vim.g["airline#extensions#hunks#enabled"] = 1      -- Show Git diff hunks in the status line
    end,
  },
}


-- Setup Plugins
require("lazy").setup(plugins, {
  defaults = { lazy = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
