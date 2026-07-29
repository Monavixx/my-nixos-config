
vim.opt.number = true
vim.opt.relativenumber = true

-- Nix LSP
vim.lsp.config('nixd', {
cmd = { 'nixd' },
settings = {
    nixd = {
    nixpkgs = { expr = "import <nixpkgs> { }" },
    formatting = { command = { "nixfmt" } },
    },
},
})
vim.lsp.enable('nixd')

-- C# / Roslyn LSP
vim.lsp.config('roslyn_ls', {
cmd = { 'Microsoft.CodeAnalysis.LanguageServer', '--stdio' },
})
vim.lsp.enable('roslyn_ls')
