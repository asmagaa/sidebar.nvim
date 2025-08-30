local Window = {}

local state = {
    buf = nil,
    win = nil,
    cfg = nil,
    last_render = 0,
}

local function now_ms()
    return vim.loop.now()
end

local function throttle_ok(ms)
    if ms <= 0 then return true end
    local t = now_ms()
    if (t - state.last_render) >= ms then
        state.last_render = t
        return true
    end
    return false
end

function Window.setup(cfg)
    state.cfg = cfg
end

local function calc_col(width, position)
    local columns = vim.o.columns
    if position == "left" then
        return 0
    else
        return math.max(columns - width, 0)
    end
end

local function ensure_buf()
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        return state.buf
    end
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = state.buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = state.buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = state.buf })
    vim.api.nvim_set_option_value("filetype", "sidebar", { buf = state.buf })
    return state.buf
end