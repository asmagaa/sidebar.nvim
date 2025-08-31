local M = {}
local config = require("sidebar.config")
local render = require("sidebar.render")
local window = require("sidebar.window")

M._state = {
    open = false,
    buf = nil,
    win = nil
}

function M.setup(user_config)
    M._config = config.extend(user_config)
end

function M.get_config()
    return M._config
end

function M.toggle()
    if M._state.open then
        M.close()
    else
        M.open()
    end
end

function M.open()
    if M._state.open then return end
    
    local cfg = M.get_config() or config.extend({})
    M._state.buf, M._state.win = window.create(cfg)

    if M._state.buf and M._state.win then
        vim.api.nvim_buf_set_option(M._state.buf, "modifiable", true)
        
        local lines = render.build_lines(cfg)
        vim.api.nvim_buf_set_lines(M._state.buf, 0, -1, false, lines)
        
        vim.api.nvim_buf_set_option(M._state.buf, "modifiable", false)
        
        M._state.open = true
    end
end

function M.close()
    if M._state.win and vim.api.nvim_win_is_valid(M._state.win) then
        vim.api.nvim_win_close(M._state.win, true)
    end
    if M._state.buf and vim.api.nvim_buf_is_valid(M._state.buf) then
        vim.api.nvim_buf_delete(M._state.buf, { force = true })
    end
    M._state.open = false
    M._state.buf = nil
    M._state.win = nil
end

M.setup({})

return M