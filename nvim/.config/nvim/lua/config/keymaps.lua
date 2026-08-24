-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer navigation
map("n", "<leader>bn", ":bnext<CR>", opts)
map("n", "<leader>bp", ":bprev<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Quick save
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)

-- Clear highlights
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Better indenting in visual mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines
map("n", "<A-j>", ":move .+1<CR>==", opts)
map("n", "<A-k>", ":move .-2<CR>==", opts)
map("v", "<A-j>", ":move '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":move '<-2<CR>gv=gv", opts)

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- Neo-tree toggle
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", opts)

-- LSP
map("n", "<leader>li", "<cmd>LspInfo<CR>", opts)

-- Diagnostics
map("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", opts)
map("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
map("n", "]d", function() vim.diagnostic.goto_next() end, opts)
