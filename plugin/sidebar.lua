vim.api.nvim_create_user_command("SidebarToggle", function()
    require("sidebar").toggle()
end, { desc = "Toggle sidebar.nvim" })