-- Core Neovim Settings

local opt = vim.opt
local g = vim.g

-- Disable netrw in favor of neo-tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.colorcolumn = "120"
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Performance
opt.updatetime = 200
opt.timeoutlen = 500

-- Files
opt.undofile = true
opt.backup = false
opt.swapfile = false

-- Splitting
opt.splitbelow = true
opt.splitright = true

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 15

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldenable = false
