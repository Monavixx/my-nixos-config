local M = {}

local state = {
    output_buf = nil,
    output_win = nil,
    last_cmd = nil,
}

--------------------------------------------------------------------------------
-- Output window
--------------------------------------------------------------------------------

local function open_output()
    if state.output_win and vim.api.nvim_win_is_valid(state.output_win) then
        vim.api.nvim_set_current_win(state.output_win)
        return state.output_buf
    end

    vim.cmd("botright 15split")

    state.output_win = vim.api.nvim_get_current_win()
    state.output_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_win_set_buf(
        state.output_win,
        state.output_buf
    )

    vim.bo[state.output_buf].buftype = "nofile"
    vim.bo[state.output_buf].bufhidden = "wipe"
    vim.bo[state.output_buf].swapfile = false
    vim.bo[state.output_buf].filetype = "dotnet-test"

    vim.keymap.set(
        "n",
        "q",
        "<cmd>close<cr>",
        {
            buffer = state.output_buf,
            silent = true,
        }
    )
    vim.keymap.set(
        "n",
        "<Esc>",
        "<cmd>close<cr>",
        {
            buffer = state.output_buf,
            silent = true,
        }
    )

    return state.output_buf
end


local function show_output(lines)
    local buf = open_output()

    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        lines
    )
    vim.api.nvim_win_set_cursor(
        state.output_win,
        {
            vim.api.nvim_buf_line_count(buf),
            0,
        }
    )
end


--------------------------------------------------------------------------------
-- Runner
--------------------------------------------------------------------------------

local function run(cmd)
    state.last_cmd = cmd

    show_output({
        "Running:",
        "",
        table.concat(cmd, " "),
        "",
        "--------------------------------",
    })

    vim.system(
        cmd,
        {
            text = true,
        },
        function(result)
            local lines = {}

            if result.stdout then
                vim.list_extend(
                    lines,
                    vim.split(
                        result.stdout,
                        "\n"
                    )
                )
            end

            if result.stderr then
                vim.list_extend(
                    lines,
                    {
                        "",
                        "stderr:",
                        "",
                    }
                )

                vim.list_extend(
                    lines,
                    vim.split(
                        result.stderr,
                        "\n"
                    )
                )
            end


            vim.schedule(function()
                show_output(lines)
            end)
        end
    )
end


--------------------------------------------------------------------------------
-- Project discovery
--------------------------------------------------------------------------------

local function find_csproj(path)
    local dir = vim.fs.dirname(path)

    while dir do
        local result = vim.fs.find(
            function(name)
                return name:match("%.csproj$")
            end,
            {
                path = dir,
                type = "file",
                limit = 1,
            }
        )

        if #result > 0 then
            return result[1]
        end


        local parent = vim.fs.dirname(dir)

        if parent == dir then
            break
        end

        dir = parent
    end

    return nil
end


--------------------------------------------------------------------------------
-- Treesitter helpers
--------------------------------------------------------------------------------

local test_attributes = {
    Fact = true,
    Theory = true,

    Test = true,
    TestCase = true,

    TestMethod = true,
}


local function node_text(node)
    return vim.treesitter.get_node_text(
        node,
        0
    )
end


local function find_parent(node, type)
    while node do
        if node:type() == type then
            return node
        end

        node = node:parent()
    end
end


local function get_namespace(root)
    local function visit(node)
        if node:type() == "namespace_declaration"
            or node:type() == "file_scoped_namespace_declaration"
        then
            local name = node:field("name")[1]

            if name then
                return vim.treesitter.get_node_text(
                    name,
                    0
                )
            end
        end


        for child in node:iter_children() do
            local result = visit(child)

            if result then
                return result
            end
        end
    end

    return visit(root) or ""
end


local function has_test_attribute(method)
    for child in method:iter_children() do
        if child:type() == "attribute_list" then
            local text = vim.treesitter.get_node_text(
                child,
                0
            )

            for name, _ in pairs(test_attributes) do
                if text:match(name) then
                    return true
                end
            end
        end
    end

    return false
end

local function nearest_test()
    local node =
        vim.treesitter.get_node()

    if not node then
        return nil
    end


    local method =
        find_parent(
            node,
            "method_declaration"
        )


    if not method then
        return nil
    end


    if not has_test_attribute(method) then
        return nil
    end


    local name =
        method:field("name")[1]


    local class =
        find_parent(
            method,
            "class_declaration"
        )


    if not class then
        return nil
    end


    local class_name =
        class:field("name")[1]


    local root =
        vim.treesitter.get_parser()
        :parse()[1]
        :root()


    local ns =
        get_namespace(root)


    local parts = {}

    if ns ~= "" then
        table.insert(parts, ns)
    end


    table.insert(
        parts,
        node_text(class_name)
    )

    table.insert(
        parts,
        node_text(name)
    )


    return table.concat(
        parts,
        "."
    )
end


--------------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------------

function M.all()
    run({
        "dotnet",
        "test",
    })
end

function M.last()
    if not state.last_cmd then
        vim.notify(
            "No previous test",
            vim.log.levels.WARN
        )

        return
    end


    run(state.last_cmd)
end

function M.nearest()
    local test =
        nearest_test()


    if not test then
        vim.notify(
            "No test method found",
            vim.log.levels.ERROR
        )

        return
    end


    local csproj =
        find_csproj(
            vim.api.nvim_buf_get_name(0)
        )


    run({
        "dotnet",
        "test",
        csproj,
        "--filter",
        "FullyQualifiedName=" .. test,
    })
end

function M.file()
    local parser =
        vim.treesitter.get_parser(0, "c_sharp")

    local root =
        parser:parse()[1]:root()

    local function find_class(node)
        if node:type() == "class_declaration" then
            return node
        end

        for child in node:iter_children() do
            local result = find_class(child)

            if result then
                return result
            end
        end
    end


    local class = find_class(root)

    if not class then
        vim.notify(
            "No class found in file",
            vim.log.levels.ERROR
        )
        return
    end


    local class_name_node =
        class:field("name")[1]

    if not class_name_node then
        vim.notify(
            "Cannot determine class name",
            vim.log.levels.ERROR
        )
        return
    end


    local class_name =
        vim.treesitter.get_node_text(
            class_name_node,
            0
        )


    local namespace =
        get_namespace(root)


    local filter

    if namespace ~= "" then
        filter =
            namespace .. "." .. class_name
    else
        filter = class_name
    end


    run({
        "dotnet",
        "test",
        "--filter",
        "FullyQualifiedName~" .. filter,
    })
end

function M.setup()
    vim.api.nvim_create_user_command(
        "DotnetTestAll",
        M.all,
        {}
    )

    vim.api.nvim_create_user_command(
        "DotnetTestLast",
        M.last,
        {}
    )

    vim.api.nvim_create_user_command(
        "DotnetTestNearest",
        M.nearest,
        {}
    )
    vim.api.nvim_create_user_command(
        "DotnetTestFile",
        M.file,
        {}
    )
end

return M
