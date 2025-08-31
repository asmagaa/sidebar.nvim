local config = require("sidebar.config")
local render = require("sidebar.render")
local window = require("sidebar.window")

local M = {}

function M.setup(opts)
    config.setup(opts or {})
end

function M.toggle()
    if window.is_open() then
    window.close()
    else
    render.show()
    end
end

return M
