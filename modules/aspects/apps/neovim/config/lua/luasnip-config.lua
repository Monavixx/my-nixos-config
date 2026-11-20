local ls = require("luasnip")

require("luasnip.loaders.from_lua").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
})
require("luasnip.loaders.from_vscode").lazy_load()
