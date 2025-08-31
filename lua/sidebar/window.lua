local M = {}

function M.create(cfg)
    local buf = vim.api.nvim_create_buf(false, true)
    if not buf then return nil, nil end

    local width = cfg.width or 30
    local col = cfg.position == "right" and (vim.o.columns - width) or 0

    local win_opts = {
        relative = "editor",
        width = width,
        height = vim.o.lines - 2,
        col = col,
        row = 1,
        style = "minimal",
        border = cfg.border or "single"
    }

    local win = vim.api.nvim_open_win(buf, false, win_opts)
    if not win then return nil, nil end

    vim.api.nvim_win_set_option(win, "winblend", 10)
    vim.api.nvim_win_set_option(win, "wrap", true)
    
    if cfg.winhl then
        vim.api.nvim_win_set_option(win, "winhighlight", cfg.winhl)
    end
    
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    return buf, win
end

return M