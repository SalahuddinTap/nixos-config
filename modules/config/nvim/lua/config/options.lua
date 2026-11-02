-- ~/.config/nvim/lua/config/options.lua
-- Core options matching Kitty/Quickshell aesthetic

local opt = vim.opt

-- UI
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes:1"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "number"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 10
opt.showmode = false
opt.showcmd = false
opt.ruler = false
opt.laststatus = 3
opt.cmdheight = 0
opt.conceallevel = 2
opt.concealcursor = "nc"

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true
opt.autowrite = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Completion
opt.completeopt = "menu,menuone,noselect,preview"
opt.wildmode = "longest:full,full"
opt.wildignorecase = true

-- Mouse
opt.mouse = "a"
opt.mousemoveevent = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Performance
opt.updatetime = 200
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.redrawtime = 1500

-- Folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldcolumn = "0"

-- Formatting
opt.formatoptions = "jcroqlnt"

-- Grep
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Spell
opt.spelllang = { "en" }
opt.spelloptions = "camel"

-- Session
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Virtual edit
opt.virtualedit = "block"

-- Diff
opt.diffopt:append("linematch:60")
opt.diffopt:append("algorithm:histogram")
opt.diffopt:append("indent-heuristic")

-- List chars
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·", nbsp = "␣", extends = "→", precedes = "←" }

-- Fill chars
opt.fillchars = {
  fold = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldsep = "│",
  diff = "╱",
  eob = " ",
  msgsep = "─",
}

-- Provider
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0