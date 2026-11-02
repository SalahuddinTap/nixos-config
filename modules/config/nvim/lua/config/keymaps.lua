-- ~/.config/nvim/lua/config/keymaps.lua
-- Basic keymaps

local map = vim.keymap.set

-- Better escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Better indent
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Save file
map({ "n", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy" })

-- Mason
map("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Mason" })