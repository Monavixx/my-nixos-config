vim.opt.termguicolors = true
require("catppuccin").setup({
    flavour = "mocha",
    background = {
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true,
})
vim.cmd.colorscheme("catppuccin-nvim")

require("languages.lua")

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    signs = true,
    update_in_insert = false,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Nix LSP
vim.lsp.config("nixd", {
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
})
vim.lsp.enable("nixd")
require("roslyn").setup({
	filewatching = "auto",
})
require("blink.cmp").setup({
    keymap = {
        preset = "enter",
    },

    signature = { enabled = true },

    appearance = {
	    use_nvim_cmp_as_default = false,
        nerd_font_variant = "normal",
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
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
