vim.lsp.config('qmlls', {
    cmd = { 'qmlls', '-E' },
    filetypes = { 'qml', 'qmljs' },
    root_markers = { 'qmldir', '.git' },
})

vim.lsp.enable('qmlls')
