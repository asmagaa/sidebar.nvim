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
        table.insert(lines, string.rep("-", cfg.width - 2 > 0 and (cfg.width - 2) or 10))
    end

    table.insert(lines, cfg.title)
    sep()
    table.insert(lines, ("File: %s"):format(path))
    table.insert(lines, ("Type: %s  Modified: %s"):format(filetype, modified))
    table.insert(lines, ("Size: %s  Lines: %d   Words: %d"):format(size, line_count, words))
    table.insert(lines, ("Encoding: %s  EOL: %s"):format(encoding, ff))
    sep()
    table.insert(lines, ("Git: %s   Changed: %d"):format(git.branch, git.changed))
    table.insert(lines, ("Diagnostics  E:%d  W:%d H:%d"):format(diag.err, diag.warn, diag.info, diag.hint))
    sep()
    table.insert(lines, "Tips:")
    table.insert(lines, "   :SidebarToggle  -  show/hide")
    table.insert(lines, "   config width/position/border")

    return lines
end

return M