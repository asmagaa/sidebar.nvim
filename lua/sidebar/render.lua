local M = {}

local function human_size(bytes)
    if type(bytes) ~= "number" or bytes < 0 then
        return "n/a"
    end
    local units = { "B", "KB", "MB", "GB" }
    local i = 1
    while bytes >= 1024 and i < #units do
        bytes = bytes / 1024
        i = i + 1
    end
    return string.format("%.1f %s", bytes, units[i])
end

local function current_filepath()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return "[No Name]"
    end
    return vim.fn.fnamemodify(name, ":p")
end

local function file_size_safe(path)
    if path == "[No Name]" then
        return -1
    end
    local ok, stat = pcall(vim.loop.fs_stat, path)
    if ok and stat and stat.size then
        return stat.size
    end
    return -1
end

local function diag_counts()
    local severities = {
        ERROR = vim.diagnostic.severity.ERROR,
        WARN = vim.diagnostic.severity.WARN,
        INFO = vim.diagnostic.severity.INFO,
        HINT = vim.diagnostic.severity.HINT,
    }
    local buf = 0
    local function count(sev)
        local t = vim.diagnostic.get(buf, { severity = sev })
        return #t
    end
    return {
        err = count(severities.ERROR),
        warn = count(severities.WARN),
        info = count(severities.INFO),
        hint = count(severities.HINT),
    }
end

local function git_branch_and_changes()
    local function syslist(cmd)
        local ok, out = pcall(vim.fn.systemlist, cmd)
        if not ok or vim.v.shell_error ~= 0 then
            return nil
        end
        return out
    end

    local root = syslist({ "git", "rev-parse", "--show-toplevel" })
    if not root or #root == 0 then
        return { branch = "-", changed = 0 }
    end

    local branch = syslist({ "git", "rev-parse", "--abbrev-ref", "HEAD" })
    if not branch or #branch == 0 then
        branch = { "-" }
    end

    local short = syslist({ "git", "status", "--porcelain" }) or {}
    return { branch = branch[1], changed = #short }
end

local function wrap_text(text, width, indent)
    indent = indent or ""
    local lines = {}
    local current_line = ""
    local words = {}
    
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end
    
    for _, word in ipairs(words) do
        if #current_line + #word + 1 <= width then
            if current_line ~= "" then
                current_line = current_line .. " " .. word
            else
                current_line = word
            end
        else
            table.insert(lines, indent .. current_line)
            current_line = word
        end
    end
    
    if current_line ~= "" then
        table.insert(lines, indent .. current_line)
    end
    
    return lines
end

local function get_ascii_art()
    local arts = {
        [[
    ┌────────────────────┐
    │    sidebar.nvim    │
    │     by grldni      │
    └────────────────────┘
        ]],
        [[
    ╭────────────────────╮
    │     NVIM MY <3     │
    ╰────────────────────╯
        ]]
    }
    return arts[math.random(#arts)]
end

function M.build_lines(cfg)
    local lines = {}
    local path = current_filepath()
    local line_count = vim.api.nvim_buf_line_count(0)
    local wc = vim.fn.wordcount()
    local words = wc.words or 0
    local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "plain"
    local modified = vim.bo.modified and "yes" or "no"
    local encoding = vim.o.encoding
    local ff = vim.bo.fileformat
    local size = human_size(file_size_safe(path))
    local diag = diag_counts()
    local git = git_branch_and_changes()

    local function sep()
        table.insert(lines, "─" .. string.rep("─", cfg.width - 4) .. "─")
    end

    local ascii_lines = {}
    for line in get_ascii_art():gmatch("[^\r\n]+") do
        table.insert(ascii_lines, line)
    end
    for _, line in ipairs(ascii_lines) do
        table.insert(lines, line)
    end
    
    sep()

    table.insert(lines, "FILE INFO:")
    table.insert(lines, "")
    
    local file_info = {
        "Path: " .. path,
        "Language: " .. filetype,
        "Modified: " .. modified,
        "Size: " .. size,
        "Lines: " .. line_count,
        "Words: " .. words,
        "Encoding: " .. encoding,
        "EOL: " .. ff
    }
    
    for _, info in ipairs(file_info) do
        local wrapped = wrap_text(info, cfg.width - 4, "  ")
        for _, line in ipairs(wrapped) do
            table.insert(lines, line)
        end
    end
    
    sep()
    
    table.insert(lines, "GIT STATUS:")
    table.insert(lines, "")
    table.insert(lines, "  Branch: " .. git.branch)
    table.insert(lines, "  Changed files: " .. git.changed)
    
    sep()
    
    table.insert(lines, "DIAGNOSTICS:")
    table.insert(lines, "")
    table.insert(lines, "  Errors: " .. diag.err)
    table.insert(lines, "  Warnings: " .. diag.warn)
    table.insert(lines, "  Info: " .. diag.info)
    table.insert(lines, "  Hints: " .. diag.hint)
    
    sep()
    
    table.insert(lines, "TIPS:")
    table.insert(lines, "")
    local tips = {
        ":SidebarToggle - Toggle sidebar visibility",
        "Configure width, position, border in setup",
        "Automatic updates on file changes"
    }
    
    for _, tip in ipairs(tips) do
        local wrapped = wrap_text(tip, cfg.width - 4, "  • ")
        for _, line in ipairs(wrapped) do
            table.insert(lines, line)
        end
    end

    return lines
end

return M