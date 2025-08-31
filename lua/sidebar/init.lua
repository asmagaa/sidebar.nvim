local cfgmod = require("sidebar.config")
local window = require("sidebar.window")
local render = require("Sidebar.render")

local M = {}
local augroup = vim.api.nvim_create_augroup("SidebarNvim", { clear = true })
local current_cfg = nil

local function _render()
    if not window.is_open() then
        return
    end
    local lines = render.build_lines(current_cfg)
    window.render(lines)
end

local function _reposition()
    if not window.is_open() then
        return
    end
    window.reposition()
    _render()
end

local function setup_autocmds(cfg)
    vim.api.nvim_clear_autocmds({ group = augroup })
    for _, ev in ipairs(cfg.update_events) do
        vim.api.nvim_create_autocmd(ev, {
            group = augroup,
            callback = function()
                if ev == "VimResized" then
                    _reposition()
                else
                    _render()
                end
            end,
            desc = "sidebar.nvim auto-update",
        })
    end
end