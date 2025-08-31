# sidebar.nvim

## What?
**sidebar.nvim** is a lightweight and simple sidebar plugin for Neovim. Its job is easy, to display basic file information (such as size and langage "type"), git status, diagnostics, etc...

***cool shields***

![sidebar.nvim](https://img.shields.io/badge/Neovim-0.5%2B-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

## Installation
### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "asmagaa/sidebar.nvim",
    config = function()
        require("sidebar").setup({
            width = 35,
            position = "right",
            border = "rounded",
            title = "sidebar.nvim",
        })
    end,
}
```

### Using [packer.nvim]((https://github.com/wbthomason/packer.nvim))

```lua
    use {
    "asmagaa/sidebar.nvim",
    config = function()
        require("sidebar").setup({
        })
    end,
}
```

### Manual

```lua
git clone https://github.com/asmagaa/sidebar.nvim ~/.config/nvim/pack/plugins/start/sidebar.nvim
```

## Configuration
*You see this ***config...*** thing? Here is what to do:*
```lua
require("sidebar").setup({
    width = 30, -- Width 
    position = "left", -- Position ("left" or "right")
    border = "single", -- Border style (ex: "single", "rounded", etc...)
    title = "sidebar.nvim", -- Title display
    update_events = { -- Events
        "BufEnter",
        "BufWritePost",
        "DiagnosticChanged",
        "CursorHold",
        "VimResized",
    },
    throttle_ms = 120, -- Throttle update frequency (ms)
    winhl = "Normal:NormalFloat,FloatBorder:FloatBorder", -- Window highlighting
})
```

And here is default config if no configuration is provided (yes, its the same as up here):
```lua
{
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
```

## Commands

- :SidebarToggle - Toggle sidebar visibility.
- :SidebarOpen - Open the sidebar.
- :SidebarClose - Close the sidebar.