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

M.buf - vim.api.nvim_create_buf(false, true)

local columns = vim.o.columns
local width = M.width
local col = M.position == "left" and 0 or (columns - width)