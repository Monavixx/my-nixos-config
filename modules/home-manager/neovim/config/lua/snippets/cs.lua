local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local function get_class_name()
    local parser = vim.treesitter.get_parser(0, "c_sharp")
    local tree = parser:parse()[1]
    local root = tree:root()

    local query = vim.treesitter.query.parse(
        "c_sharp",
        [[
(class_declaration
  name: (identifier) @name)
]]
    )

    for _, node in query:iter_captures(root, 0) do
        return vim.treesitter.get_node_text(node, 0)
    end

    return "ClassName"
end

local function class_name_node()
    return sn(nil, {
        i(1, get_class_name()),
    })
end

return {
    s("fact", {
        t({
            "[Fact]",
            "public async Task ",
        }),
        i(1, "TestName"),
        t({
            "()",
            "{",
            "    ",
        }),
        i(0),
        t({
            "",
            "}",
        }),
    }),
    s("theory", {
        t({
            "[Theory]",
            "[InlineData(",
        }),
        i(1, "data"),
        t({
            ")]",
            "public async Task ",
        }),
        i(2, "TestName"),
        t({
            "(",
        }),
        i(3, "parameters"),
        t({
            ")",
            "{",
            "    ",
        }),
        i(0),
        t({
            "",
            "}",
        }),
    }),
    s("ctor", {
        t("public "),
        d(1, class_name_node, {}),
        t({
            "()",
            "{",
            "    ",
        }),
        i(0),
        t({
            "",
            "}",
        }),
    }),
    s("foreach", {
        t({
            "foreach (var ",
        }),
        i(1, "item"),
        t({
            " in ",
        }),
        i(2, "collection"),
        t({
            ")",
            "{",
            "    ",
        }),
        i(0),
        t({
            "",
            "}",
        }),
    }),

}
