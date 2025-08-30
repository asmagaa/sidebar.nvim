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