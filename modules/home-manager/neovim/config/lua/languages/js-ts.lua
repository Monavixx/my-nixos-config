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
