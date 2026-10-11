vim.lsp.config("roslyn", {
    cmd = {
        "Microsoft.CodeAnalysis.LanguageServer", -- or "roslyn-language-server"
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
    },
    -- keep your existing settings/capabilities here
})

require("roslyn").setup({
    filewatching = "auto",
    config = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    },
})
require("boilersharp").setup({})
