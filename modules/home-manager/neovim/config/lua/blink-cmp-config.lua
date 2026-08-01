require("blink.cmp").setup({
    keymap = {
        preset = "enter",
        ['<Esc>'] = { "hide", "fallback" }
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
            if type == ':' then
                return { 'cmdline' }
            elseif type == '/' or type == '?' then
                return { 'buffer' }
            end
            return {}
        end,
        completion = {
            menu = { auto_show = true },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false, -- Automatically inserts the choice as you navigate
                }
            }
        }
    },
    completion = {
        ghost_text = {
            enabled = false,
            -- show_with_menu = true,
            -- show_without_menu = true,
        },
        menu = {
            border = "rounded",
            draw = {
                columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "source_id" } },
                treesitter = { 'lsp' },
            }
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
        default = { "lsp", "path", "buffer", "snippets" },
        providers = {
            buffer = {
                max_items = 3,
            },
        },

        fuzzy = {
            implementation = "prefer_rust_with_warning",
        },
        snippets = {
            preset = "luasnip",
        },
    }
})
