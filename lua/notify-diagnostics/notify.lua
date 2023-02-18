local utils = require("notify-diagnostics.utils")
local tables = require("notify-diagnostics.tables")

-- Creates an object for the module.
local M = {}

-- Displays LSP diagnostics with nvim-notify
function M.diagnostics()
    -- Clear previous notifications
    local notify = require("notify")
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
                    _ = notify(notify_textbox, level, vim.g.notifydiagnostics_config["notify_options"])
                end
            end
        end
    end
end

return M
