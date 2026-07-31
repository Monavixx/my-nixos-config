local options = { noremap = true, silent = true }

-- Sets <Space> as a leader
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, options)
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, options)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, options)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, options)

-- Telescope
local builtinTelescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtinTelescope.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtinTelescope.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtinTelescope.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtinTelescope.help_tags, { desc = "Help" })
vim.keymap.set("n", "<leader>fr", builtinTelescope.lsp_references, { desc = "References" })
vim.keymap.set("n", "<leader>fd", builtinTelescope.lsp_definitions, { desc = "Definitions" })

-- Neotree
vim.keymap.set("n", "<Tab>", "<C-w>w", options)
