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

