local M = {}

M.defaults = {
    width = 30,
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

return M