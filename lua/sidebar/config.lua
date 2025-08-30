local M = {}

M.defaults = {
    width = thirty_or_default(30),
    position = "left",
    border = "single",
    title = "sidebar.nvim",
    update_events = {
        "BufEnter",
        "BufWritePost",
        "DiagnosticChanged",
        "CursorHold",
        "VimResized",
    },
    throttle_ms = 120,
    winhl = "Normal:NormalFloat,FloatBorder:FloatBorder",
}

function M.extend(user)
    user = user or {}
    local out = {}
    for k, v in pairs(M.defaults) do out[k] = v end
    for k, v in pairs(user) do out[k] = v end
    return out
end

function thirty_or_default(v)
    if type(v) == "number" and v > 8 and v < 120 then
        return v
    end
    return _thirty()
end

return M