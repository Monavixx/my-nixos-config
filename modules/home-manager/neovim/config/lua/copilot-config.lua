vim.g.copilot_nes_debounce = 500

require("copilot").setup({
    nes = {
        enabled = true,
        keymap = {
            accept_and_goto = "<leader>p",
            accept = false,
            dismiss = "<Esc>",
        },
    },
    filetypes = {
        cs = true,
        js = true,
        ts = true,
        html = true,
        css = true,
        rs = true,
        py = true,
        ["*"] = false
    },
    panel = {
        auto_refresh = true,
    }
})
