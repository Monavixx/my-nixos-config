require("roslyn").setup({
    filewatching = "auto",
    config = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    },
})
require("boilersharp").setup({})
