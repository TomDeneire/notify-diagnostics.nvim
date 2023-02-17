-- Creates an object for the module.
local M = {}

-- Diagnostic severity table
M.severity = function()
    local table = {
        warn = vim.diagnostic.severity.WARN,
        info = vim.diagnostic.severity.INFO,
        hint = vim.diagnostic.severity.HINT,
        error = vim.diagnostic.severity.ERROR
    }
    return table
end

-- Diagnostic icons table
M.icons = function()
    local table = {
        debug = "",
        error = "",
        info = "",
        hint = "✎",
        trace = "✎",
        warn = ""
    }
    return table
end

return M
