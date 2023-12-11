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
    local notify = require("notify")
    -- Clear previous notifications
    notify.dismiss()
    vim.g.notifydiagnostics_enable = false
end

-- Displays LSP diagnostics with nvim-notify
function M.diagnostics()
    local notify = require("notify")
    -- Clear previous notifications
    notify.dismiss()

    -- Handle LSP diagnostic severity_levels
    local config = vim.g.notifydiagnostics_config
    local max = 10
    for level in pairs(config.severity_levels) do
        if config.severity_levels[level] == true then
            local diagnostics = vim.diagnostic.get(
                0, { severity = tables.severity()[level] })
            if diagnostics ~= nil then
                local notify_textbox = ""
                local notify_diagnostics = {}
                local unique_count = 0
                for j in pairs(diagnostics) do
                    local diagnostic = diagnostics[j]
                    local code = utils.split(diagnostic.message, " ")
                    local code_clean = string.gsub(code[1], " ", "")
                    if config.exclude_codes[code_clean] == nil then
                        local message = ""
                        if config.notify_options.render == "minimal" then
                            message = message .. tables.icons()[level] .. " "
                        end
                        message = message .. diagnostic.lnum + 1 .. ": " .. diagnostic.message
                        message = utils.insertNewLines(message, config.max_width)
                        if j ~= utils.table_length(diagnostics) then
                            message = message .. "\n"
                        end
                        unique_count = unique_count + 1
                        notify_diagnostics[diagnostic.lnum + unique_count] = message
                    end
                end
                local message_count = 0
                for _, diagnostic in pairs(notify_diagnostics) do
                    message_count = message_count + 1
                    if message_count == max then
                        local moreinfo = "(" .. #notify_diagnostics - max .. " more messages"
                        notify_textbox = notify_textbox .. moreinfo
                        break
                    end
                    notify_textbox = notify_textbox .. diagnostic
                end
                if notify_textbox ~= "" then
                    local record_id = config.records[level]
                    config["notify_options"]["replace"] = record_id
                    local record = notify(notify_textbox, level,
                        config["notify_options"])
                    config.records[level] = record.id
                end
            end
        end
    end
end

-- function Test()
--     local notify = require("notify")
--     local level = "warn"
--     config["notify_options"]["replace"] = vim.g.notifydiagnostics_config
--         .records[level]
--     print(config.records[level])
--     local record = notify("test", level, config["notify_options"])
--     config.records[level] = record.id
-- end

return M
