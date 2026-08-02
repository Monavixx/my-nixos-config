vim.g.copilot_nes_debounce = 500

require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = false,
        trigger_on_accept = false,
        keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = false,
            prev = false,
            dismiss = false,
            toggle_auto_trigger = false,
        },
    },
    panel = {
        enabled = false,
    },
})

require("CopilotChat").setup()
