require("blink.cmp").setup({
    keymap = {
        preset = "enter",
    },

    signature = { enabled = true },

    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "normal",
    },
    cmdline = {
        enabled = true,
        keymap = {
            preset = 'cmdline', -- Pre-configured keys for cmdline (e.g. Tab/S-Tab)
        },
        sources = function()
            local type = vim.fn.getcmdtype()
            -- Only use the cmdline source when typing commands (:)
            if type == ':' then return { 'cmdline' } end
            -- Disable or use buffer completions during search (/ or ?)
            return {}
        end,
        completion = {
            menu = { auto_show = true },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true, -- Automatically inserts the choice as you navigate
                }
            }
        }
    },
    completion = {
        menu = {
            border = "rounded",
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            },
        },
        documentation = {
            window = {
                border = "rounded",
            },
            auto_show = true,
        },
    },

    sources = {
        default = { "lsp", "path", "buffer" },
    },

    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },
})
