local M = {}

function M.setup(opts)
    opts = opts or {}
    M.width = opts.width or 30
    M.position = opts.position or "left"
    M.buf = nil
    M.win = nil
end

function M.toggle()
    if M.win and vim.api.nvim_win_is_valid(M.win) then
        vim.api.nvim_win_close(M.win, true)
        M.win = nil
        return
    end
end