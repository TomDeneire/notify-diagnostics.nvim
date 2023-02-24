-- Imports the plugin's additional Lua modules.
local notify = require("notify-diagnostics.notify")

-- Default user config
dd
local function default_options()
    local options = {
        exclude_codes = {}, -- e.g. {E501 = true}
        severity_levels = {
            info = false,
            hint = false,
            warn = true,
            error = true },
        notify_options = {
            title = "LSP diagnostics",
            render = "minimal", -- "default", "minimal", "simple", "compact"
            animate = "static", -- "fade_in_slide_out", "fade", "slide", "static"
            max_width = 10,
            minimum_width = 10,
            timeout = false -- boolean, int
        },
        autocommands = { "BufEnter", "BufWritePre", "BufWritePost" }
    }

    return options
end

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.

local M = {}

M.init = function()
    if not vim.g.notifydiagnostics_namespace then
        vim.g.notifydiagnostics_namespace = vim.api.nvim_create_namespace "notifydiagnostics"
    end
end

-- Setup with user configuration
M.setup = function(user_options)
    -- default options
    local options = default_options()
    if user_options ~= nil then
        for k, v in pairs(user_options) do
            options[k] = v
        end
    end

    -- add default notification records
    options.records = { info = nil, hint = nil, warn = nil, error = nil }

    -- register options
    vim.g.notifydiagnostics_config = options

    -- enable
    vim.g.notifydiagnostics_enable = true

    local autocommands = options.autocommands
    for i in pairs(autocommands) do
        local autocmd = autocommands[i]
        vim.api.nvim_create_autocmd(autocmd, {
            command = "silent! Notifylspdiagnostics",
        })
    end
end

-- Routes calls made to this module to functions in the
-- plugin's other modules.
-- M.diagnostics = notify.diagnostics

M.diagnostics = notify.diagnostics
M.enable = notify.enable
M.disable = notify.disable

return M
