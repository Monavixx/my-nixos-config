require("catppuccin-config")
require("languages.all")
require("keybinds")
require("blink-cmp-config")
require("treesitter-config")
require("telescope-config")
require("autopairs-config")
require("neotree-config")

vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.softtabstop    = 4
vim.opt.number         = true
vim.opt.relativenumber = true

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    signs = true,
    update_in_insert = false,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    },
})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
