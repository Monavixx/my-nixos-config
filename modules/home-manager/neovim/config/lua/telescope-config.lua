require("telescope").setup({
    defaults = {
        sorting_strategy = "ascending", -- try switching back to descending
        layout_config = {
            prompt_position = "bottom",
        },
        path_display = { "filename_first" }
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    }
})
require("telescope").load_extension("ui-select")
