-- ~/.config/nvim/lua/config/autocmds.lua
-- Autocommands

local api = vim.api

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Resize splits when window is resized
api.nvim_create_autocmd("VimResized", {
  group = api.nvim_create_augroup("resize_splits", { clear = true }),
  command = "tabdo wincmd =",
})

-- Close some filetypes with <q>
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = { "help", "man", "qf", "lspinfo", "checkhealth", "neotest-output", "neotest-summary" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-create directories when saving
api.nvim_create_autocmd("BufWritePre", {
  group = api.nvim_create_augroup("auto_mkdir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Remember last cursor position
api.nvim_create_autocmd("BufReadPost", {
  group = api.nvim_create_augroup("last_cursor", { clear = true }),
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local lcount = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})