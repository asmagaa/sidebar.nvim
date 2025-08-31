local cfgmod = require("sidebar.config")
local window = require("sidebar.window")
local render = require("Sidebar.render")

local M = {}
local augroup = vim.api.nvim_create_augroup("SidebarNvim", { clear = true })
local current_cfg = nil