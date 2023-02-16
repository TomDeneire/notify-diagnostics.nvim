local utils = require("lsp-notify.utils")
local tables = require("lsp-notify.tables")

-- Creates an object for the module.
local M = {}

-- Displays LSP diagnostics with nvim-notify
function M.diagnostics()
    -- Get configurations
    local severity_table = tables.severity()
    local icons_table = tables.icons()
    local config = vim.g.lspnotify_config

    -- Clear previous notifications
    local notify = require("notify")
    notify.dismiss()

    -- Handle LSP diagnostic severity_levels
    for level in pairs(config.severity_levels) do
        if config.severity_levels[level] == true then
            local diagnostics = vim.diagnostic.get(
                0, { severity = severity_table[level] })
            if diagnostics ~= nil then
                local notify_textbox = ""
                for j in pairs(diagnostics) do
                    local diagnostic = diagnostics[j]
                    local code = utils.split(diagnostic.message, " ")
                    local code_clean = string.gsub(code[1], " ", "")
                    if config.exclude_codes[code_clean] == nil then
                        local message = utils.insertNewLines(diagnostic.message)
                        local n = ""
                        if config.notify_options.render == "minimal" then
                            n = icons_table[level] .. " "
                        end
                        n = n .. diagnostic.lnum + 1 .. ": " .. message
                        if j ~= utils.table_length(diagnostics) then
                            n = n .. "\n"
                        end
                        notify_textbox = notify_textbox .. n
                    end
                end
                if notify_textbox ~= "" then
                    _ = notify(notify_textbox, level, config["notify_options"])
                end
            end
        end
    end
end

return M
