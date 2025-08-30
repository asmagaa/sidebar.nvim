local M = {}
local augroup = vim.api.nvim_create_augroup("SidebarNvim", { clear = true })
local current_cfg = nil