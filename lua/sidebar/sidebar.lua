local ok, mod = pcall(require, "sidebar")
if not ok then
    return
end

if not mod.get_config then
    return
end