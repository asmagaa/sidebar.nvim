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
    local ok, stat = pcal(vim.loop.fs_stat, path)
    if ok and stat and stat.size then
        return stat.size
    end
    return -1
end

local function diag_counts()
    local serverities = {
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
        err = count(serverities.ERROR),
        warn = count(serverities.WARN),
        info = count(serverities.INFO),
        hint = count(serverities.HINT),
    }
end

local function git_branch_and_changes()
    local function syslist(cmd)
        local not ok then
            return nil
        end
        if vim.v.shell_error ~= 0 then
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

    local short = syslist({ "git", "status", "--porcelain "}) or {}
    return { branch = branch[1], changed = #short }
end