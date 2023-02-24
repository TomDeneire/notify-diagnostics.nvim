local utils = require("notify-diagnostics.utils")
local tables = require("notify-diagnostics.tables")

-- Creates an object for the module.
local M = {}

-- Enable LSP diagnostics
function M.enable()
    vim.g.notifydiagnostics_enable = true
end

-- Enable LSP diagnostics
function M.disable()
    local notify = vim.g.notifydiagnostics_instance
    -- Clear previous notifications
    notify.dismiss()
    vim.g.notifydiagnostics_enable = false
end

-- Displays LSP diagnostics with nvim-notify
function M.diagnostics()
    -- if vim.g.notifydiagnostics_enable == false then
    --     return
    -- end
    local notify = vim.g.notifydiagnostics_instance
    --local notify = require("notify")

    -- Clear previous notifications
    notify.dismiss()

    -- Handle LSP diagnostic severity_levels
    for level in pairs(vim.g.notifydiagnostics_config.severity_levels) do
        if vim.g.notifydiagnostics_config.severity_levels[level] == true then
            local diagnostics = vim.diagnostic.get(
                0, { severity = tables.severity()[level] })
            if diagnostics ~= nil then
                local notify_textbox = ""
                for j in pairs(diagnostics) do
                    local diagnostic = diagnostics[j]
                    local code = utils.split(diagnostic.message, " ")
                    local code_clean = string.gsub(code[1], " ", "")
                    if vim.g.notifydiagnostics_config.exclude_codes[code_clean] == nil then
                        local message = utils.insertNewLines(diagnostic.message)
                        local n = ""
                        if vim.g.notifydiagnostics_config.notify_options.render == "minimal" then
                            n = n .. tables.icons()[level] .. " "
                        end
                        n = n .. diagnostic.lnum + 1 .. ": " .. message
                        if j ~= utils.table_length(diagnostics) then
                            n = n .. "\n"
                        end
                        notify_textbox = notify_textbox .. n
                    end
                end
                if notify_textbox ~= "" then
                    local record_id = vim.g.notifydiagnostics_config.records[level]
                    vim.g.notifydiagnostics_config["notify_options"]["replace"] = record_id
                    local record = notify(notify_textbox, level,
                        vim.g.notifydiagnostics_config["notify_options"])
                    vim.g.notifydiagnostics_config.records[level] = record.id
                end
            end
        end
    end
end

-- function Test()
--     local notify = require("notify")
--     local level = "warn"
--     vim.g.notifydiagnostics_config["notify_options"]["replace"] = vim.g.notifydiagnostics_config
--         .records[level]
--     print(vim.g.notifydiagnostics_config.records[level])
--     local record = notify("test", level, vim.g.notifydiagnostics_config["notify_options"])
--     vim.g.notifydiagnostics_config.records[level] = record.id
-- end

return M
