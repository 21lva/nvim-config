local api = vim.api
local g = vim.g
local opt = vim.opt

-- Remap leader and local leader to <Space>
api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "

opt.termguicolors = true -- Enable colors in terminal
opt.hlsearch = true --Set highlight on search
opt.number = true --Make line numbers default
-- opt.relativenumber = true --Make relative number default
opt.mouse = "a" --Enable mouse mode
opt.breakindent = true --Enable break indent
opt.undofile = true --Save undo history
opt.ignorecase = true --Case insensitive searching unless /C or capital in search
opt.smartcase = true -- Smart case
opt.updatetime = 250 --Decrease update time
opt.signcolumn = "yes" -- Always show sign column
opt.clipboard = "unnamedplus" -- Access system clipboard

opt.showmatch = true
opt.autoindent = true
opt.shiftwidth = 4
opt.smarttab = true
opt.smartindent = true
opt.smartindent = true
opt.softtabstop = 4
opt.tabstop = 4

-- opt.nocompatible = true
opt.encoding = "utf-8"

-- TextEdit might fail if hidden is not set.
opt.hidden = true

-- Some servers have issues with backup files, see #649.
-- opt.nobackup = true
-- opt.nowritebackup = true

-- Give more space for displaying messages.
opt.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
opt.updatetime = 300

-- Don't pass messages to |ins-completion-menu|.
-- opt.shortmess += c

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
-- set signcolumn=yes

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]
