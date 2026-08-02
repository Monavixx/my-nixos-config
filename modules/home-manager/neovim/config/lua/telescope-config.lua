require("telescope").setup({
    defaults = {
        sorting_strategy = "ascending", -- try switching back to descending
        layout_config = {
            prompt_position = "bottom",
        },
    }
})
require("telescope").load_extension("ui-select")
