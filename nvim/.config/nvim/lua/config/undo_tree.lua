local M = {}

local state = {
    buf = nil,
    win = nil,
    source_win = nil,
    line_seq = {},
}

local function is_valid_win(win)
    return win and vim.api.nvim_win_is_valid(win)
end

local function is_valid_buf(buf)
    return buf and vim.api.nvim_buf_is_valid(buf)
end

local function close()
    if is_valid_win(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end
    state.win = nil
    state.buf = nil
    state.source_win = nil
    state.line_seq = {}
end

local function collect_entries(entries, depth, out)
    for _, entry in ipairs(entries or {}) do
        table.insert(out, {
            depth = depth,
            seq = entry.seq,
            time = entry.time,
            save = entry.save,
            newhead = entry.newhead,
        })

        if entry.alt then
            collect_entries(entry.alt, depth + 1, out)
        end
    end
end

local function get_tree()
    if not is_valid_win(state.source_win) then
        return nil
    end

    local ok, tree = pcall(vim.api.nvim_win_call, state.source_win, vim.fn.undotree)
    if ok then
        return tree
    end

    return nil
end

local function format_entry(entry, current_seq)
    local current = entry.seq == current_seq and "*" or " "
    local branch = string.rep("  ", entry.depth) .. (entry.depth > 0 and "|- " or "")
    local head = entry.newhead and "head" or ""
    local save = entry.save and ("save " .. entry.save) or ""
    local time = entry.time and os.date("%Y-%m-%d %H:%M:%S", entry.time) or ""

    return string.format("%s %s%5d  %-19s  %-6s %s", current, branch, entry.seq, time, head, save)
end

function M.refresh()
    if not is_valid_buf(state.buf) then
        return
    end

    local tree = get_tree()
    if not tree then
        close()
        return
    end

    local entries = {}
    collect_entries(tree.entries, 0, entries)
    table.sort(entries, function(left, right)
        return left.seq < right.seq
    end)

    local lines = {
        "Undo tree",
        "",
        "Enter: restore sequence    r: refresh    q: close",
        "",
        string.format("Current sequence: %s", tree.seq_cur),
        "",
    }

    state.line_seq = {}

    for _, entry in ipairs(entries) do
        table.insert(lines, format_entry(entry, tree.seq_cur))
        state.line_seq[#lines] = entry.seq
    end

    if #entries == 0 then
        table.insert(lines, "No undo entries")
    end

    vim.bo[state.buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.bo[state.buf].modifiable = false
end

local function restore_sequence()
    local seq = state.line_seq[vim.fn.line(".")]
    if not seq or not is_valid_win(state.source_win) then
        return
    end

    vim.api.nvim_win_call(state.source_win, function()
        vim.cmd("silent undo " .. seq)
    end)

    M.refresh()
end

local function create_window()
    state.source_win = vim.api.nvim_get_current_win()
    vim.cmd("botright 42vnew")

    state.win = vim.api.nvim_get_current_win()
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(state.win, state.buf)
    vim.api.nvim_win_set_option(state.win, "number", false)
    vim.api.nvim_win_set_option(state.win, "relativenumber", false)
    vim.api.nvim_win_set_option(state.win, "wrap", false)

    vim.bo[state.buf].bufhidden = "wipe"
    vim.bo[state.buf].buftype = "nofile"
    vim.bo[state.buf].filetype = "undo-tree"
    vim.bo[state.buf].modifiable = false
    vim.bo[state.buf].swapfile = false

    vim.keymap.set("n", "q", close, { buffer = state.buf, desc = "close undo tree" })
    vim.keymap.set("n", "r", M.refresh, { buffer = state.buf, desc = "refresh undo tree" })
    vim.keymap.set("n", "<CR>", restore_sequence, { buffer = state.buf, desc = "restore undo sequence" })
end

function M.toggle()
    if is_valid_win(state.win) then
        close()
        return
    end

    create_window()
    M.refresh()
end

vim.api.nvim_create_user_command("NativeUndoTree", M.toggle, {})

return M
