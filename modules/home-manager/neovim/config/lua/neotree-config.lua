require("neo-tree").setup({
    close_if_last_window = true,
    clipboard = {
        sync = "universal"
    },
    auto_clean_after_session_restore = true,
    filesystem = {
        use_libuv_file_watcher = true,
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false
        },
    },
    default_component_configs = {
        indent = {
            indent_size = 1,
        }
    },
    window = {
        width = 30,
        mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
            ["<C-l>"] = "open_in_new_instance",
        },
    },
    commands = {
        open_in_new_instance = function(state)
            local node = state.tree:get_node()

            -- Ensure the selected node is a file
            if node ~= nil and node.type == "file" then
                local filepath = node:get_id()

                vim.fn.jobstart({ "uwsm", "app", "--", "kitty", "nvim", filepath }, { detach = true })
            end
        end,
    },
})
