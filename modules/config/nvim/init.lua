-- ~/.config/nvim/init.lua
-- Modern Neovim config matching Kitty/Quickshell/Spicetify aesthetic
-- Vanta Black (pure grayscale #000000), JetBrainsMono Nerd Font

-- Load Vanta Black colorscheme first (before lazy.nvim)
require("colors.vantablack").setup()

-- Add Mason bin to END of PATH (system packages take priority)
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = vim.env.PATH .. ":" .. mason_bin

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" }, { "\nPress any key to exit..." } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys (must be set before plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load core config
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- ========================================================================
    -- UI / CORE
    -- ========================================================================
    { "stevearc/oil.nvim", opts = {}, keys = { { "-", "<cmd>Oil<CR>", desc = "Open parent directory" } } },

    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
        { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
        { "<leader>fr", "<cmd>Telescope lsp_references<CR>", desc = "References" },
        { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      },
    },

    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    { "nvim-lualine/lualine.nvim", opts = { options = { theme = "vanta-black", component_separators = "", section_separators = "" } } },

    { "akinsho/bufferline.nvim", version = "*", opts = { options = { mode = "buffers", separator_style = "thin", diagnostics = "nvim_lsp" } } },

    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { indent = { char = "│" }, scope = { enabled = false } }, lazy = false },

    { "folke/which-key.nvim", event = "VeryLazy", opts = {}, keys = { { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" } } },

    { "folke/todo-comments.nvim", event = "VimEnter", config = true },

    -- ========================================================================
    -- EDITING ENHANCEMENTS
    -- ========================================================================
    { "numToStr/Comment.nvim", opts = {} },

    { "kylechui/nvim-surround", version = "*", event = "VeryLazy", config = true },

    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

    { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local harpoon = require("harpoon")
        harpoon:setup()
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon quick menu" })
        vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
        vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
        vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
        vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
      end,
    },

    { "folke/flash.nvim", event = "VeryLazy", opts = {}, keys = { { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" }, { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" } } },

    -- ========================================================================
    -- GIT
    -- ========================================================================
    { "lewis6991/gitsigns.nvim", opts = { signs = { add = { text = "▎" }, change = { text = "▎" }, delete = { text = "▎" } }, current_line_blame = true, current_line_blame_opts = { delay = 300 } } },

    { "tpope/vim-fugitive", cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Glog" } },

    { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" }, opts = {} },

    -- ========================================================================
    -- LSP + COMPLETION (using NixOS system packages, not Mason)
    -- ========================================================================
    { "williamboman/mason.nvim", build = ":MasonUpdate", cmd = "Mason", opts = { ui = { border = "rounded" } } },

    -- mason-lspconfig disabled; we use system LSPs from nixpkgs
    -- { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim" }, opts = { ensure_installed = {}, automatic_installation = false } },

    { "neovim/nvim-lspconfig", dependencies = { "hrsh7th/cmp-nvim-lsp" }, lazy = false,
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- System LSPs (installed via nixpkgs, available in PATH)
        -- Using new vim.lsp.config API (nvim 0.11+)
        vim.lsp.config("lua_ls", {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          capabilities = capabilities,
          settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false }, telemetry = { enable = false } } },
        })
        vim.lsp.config("pyright", { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" }, capabilities = capabilities })
        vim.lsp.config("ts_ls", { cmd = { "typescript-language-server", "--stdio" }, filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, capabilities = capabilities })
        vim.lsp.config("jsonls", { cmd = { "vscode-json-language-server", "--stdio" }, filetypes = { "json", "jsonc" }, capabilities = capabilities })
        vim.lsp.config("yamlls", { cmd = { "yaml-language-server", "--stdio" }, filetypes = { "yaml" }, capabilities = capabilities })
        vim.lsp.config("bashls", { cmd = { "bash-language-server", "start" }, filetypes = { "bash", "sh" }, capabilities = capabilities })
        vim.lsp.config("html", { cmd = { "vscode-html-language-server", "--stdio" }, filetypes = { "html" }, capabilities = capabilities })
        vim.lsp.config("cssls", { cmd = { "vscode-css-language-server", "--stdio" }, filetypes = { "css", "scss", "less" }, capabilities = capabilities })
        vim.lsp.config("nil_ls", { cmd = { "nil" }, filetypes = { "nix" }, capabilities = capabilities })

        -- Enable all configured servers
        vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "jsonls", "yamlls", "bashls", "html", "cssls", "nil_ls" })

        -- Also manually start on FileType as fallback
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "lua", "python", "typescript", "typescriptreact", "javascript", "javascriptreact", "json", "jsonc", "yaml", "bash", "sh", "html", "css", "scss", "less", "nix" },
          callback = function(args)
            local ft = vim.bo[args.buf].filetype
            local server_map = {
              lua = "lua_ls", python = "pyright",
              typescript = "ts_ls", typescriptreact = "ts_ls", javascript = "ts_ls", javascriptreact = "ts_ls",
              json = "jsonls", jsonc = "jsonls", yaml = "yamlls",
              bash = "bashls", sh = "bashls", html = "html", css = "cssls", scss = "cssls", less = "cssls",
              nix = "nil_ls",
            }
            local server = server_map[ft]
            if server then
              vim.lsp.start({ name = server })
            end
          end,
        })

        -- Keymaps on attach
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
          end,
        })

        -- Diagnostics UI
        vim.diagnostic.config({
          virtual_text = { prefix = "●", spacing = 2 },
          signs = { text = { [vim.diagnostic.severity.ERROR] = "▎", [vim.diagnostic.severity.WARN] = "▎", [vim.diagnostic.severity.INFO] = "▎", [vim.diagnostic.severity.HINT] = "▎" } },
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          float = { border = "rounded", source = "if_many" },
        })
      end,
    },

    { "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then luasnip.jump(-1)
              else fallback() end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } }),
          window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
          formatting = { format = function(entry, item) item.menu = ({ nvim_lsp = "[LSP]", luasnip = "[Snip]", buffer = "[Buf]", path = "[Path]" })[entry.source.name]; return item end },
        })
      end,
    },

    -- ========================================================================
    -- FORMATTING / LINTING
    -- ========================================================================
    { "stevearc/conform.nvim", event = { "BufWritePre" }, cmd = { "ConformInfo" },
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          nix = { "nixfmt" },
          sh = { "shfmt" },
          bash = { "shfmt" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
        formatters = {
          stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
          shfmt = { prepend_args = { "-i", "2" } },
        },
      },
      keys = { { "<leader>f", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format buffer" } },
    },

    -- ========================================================================
    -- TERMINAL / SESSION / PROJECT
    -- ========================================================================
    { "akinsho/toggleterm.nvim", version = "*", config = function()
      require("toggleterm").setup({ size = 15, open_mapping = [[<C-\>]], direction = "float", float_opts = { border = "rounded" }, shade_terminals = true, start_in_insert = true })
    end, keys = { { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal", mode = { "n", "t" } } } },

    { "folke/persistence.nvim", event = "BufReadPre", config = true },

    { "ahmedkhalf/project.nvim", config = function()
      require("project_nvim").setup({ detection_methods = { "pattern", "lsp" }, patterns = { ".git", "package.json", "Cargo.toml", "pyproject.toml", "flake.nix", "go.mod" } })
      require("telescope").load_extension("projects")
    end, keys = { { "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Projects" } } },

    -- ========================================================================
    -- DIAGNOSTICS / TROUBLE
    -- ========================================================================
    { "folke/trouble.nvim", opts = {}, cmd = "Trouble", keys = { { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" }, { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" }, { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" }, { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP Definitions/References (Trouble)" }, { "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" }, { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" } } },

    -- ========================================================================
    -- TREESITTER (new API for main branch)
    -- ========================================================================
    { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate", event = { "BufReadPost", "BufNewFile" },
      config = function()
        local ts = require("nvim-treesitter")
        ts.setup({
          ensure_installed = { "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript", "tsx", "json", "yaml", "toml", "markdown", "markdown_inline", "html", "css", "nix", "dockerfile" },
          auto_install = true,
        })

        -- Enable highlighting, indent, and folding for supported filetypes
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript", "tsx", "json", "yaml", "toml", "markdown", "markdown_inline", "html", "css", "nix", "dockerfile" },
          callback = function()
            vim.treesitter.start()
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })

        -- Incremental selection keymaps
        vim.keymap.set({ "n", "x" }, "<C-space>", function()
          require("nvim-treesitter").incremental_selection()
        end, { desc = "Treesitter incremental selection" })
        vim.keymap.set({ "n", "x" }, "<bs>", function()
          require("nvim-treesitter").decremental_selection()
        end, { desc = "Treesitter decremental selection" })
      end,
    },

    { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" },
  },
  defaults = { lazy = true },
  install = { colorscheme = { "vanta-black" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = { disabled_plugins = { "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
  ui = {
    border = "rounded",
    backdrop = 100,
  },
})