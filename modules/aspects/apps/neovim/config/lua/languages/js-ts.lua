vim.lsp.config("vtsls", {
    settings = {
        vtsls = {
            autoUseWorkspaceTsdk = true,
        },
        typescript = {
            suggest = {
                completeFunctionCalls = true,
            },
        },
    },
})

vim.lsp.enable("vtsls")
vim.lsp.enable({
    "html",
    "cssls",
    "jsonls",
    "eslint",
})
vim.lsp.enable("tailwindcss")
