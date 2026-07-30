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
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, options)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, options)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, options)
