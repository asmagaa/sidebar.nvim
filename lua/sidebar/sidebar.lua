local ok, mod = pcall(require, "sidebar")
if not ok then
    return
end

if not mod.get_config then
    return
end

if modget_config() == nil then
    pcall(mod.setup, {})
end

vim.api.nvim_create_user_command("SidebarToggle", function() 
    require("sidebar").toggle()
end, { desc = "Toggle sidebar.nvim" })

vim.api.nvim_create_user_command("SidebarOpen", function()
    require("sidebar").open()
end, { desc = "Open sidebar.nvim" })

vim.api.nvim_create_user_command("SidebarClose", function()
    require("sidebar").close()
end, { desc = "Close sidebar.nvim" })