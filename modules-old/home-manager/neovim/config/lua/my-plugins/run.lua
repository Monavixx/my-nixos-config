vim.api.nvim_create_user_command("Run", function()
    if vim.fn.filereadable("./run.sh") == 0 then
        return
    end

    vim.cmd("botright new")
    vim.cmd("resize 15")

    local buf = vim.api.nvim_get_current_buf()

    local job_id = vim.fn.jobstart("./run.sh", {
        term = true,
    })

    local exitFunc = function()
        if job_id > 0 then
            vim.fn.jobstop(job_id)
        end

        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
    vim.keymap.set("t", "<Esc>", exitFunc, { buffer = buf })
    vim.keymap.set("t", "q", exitFunc, { buffer = buf })

    vim.cmd("startinsert")
end, {})
