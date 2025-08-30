local M = {}

function M.setup(opts)
    opts = opts or {}
    M.width = opts.width or 30
    M.position = opts.position or "left"
    M.buf = nil
    M.win = nil
end