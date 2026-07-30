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
