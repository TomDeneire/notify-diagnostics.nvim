-- Imports the plugin's additional Lua modules.
local notify = require("lsp-notify.notify")

-- Default user config
local function default_options()
    local config = {
        exclude_codes = {}, -- e.g. E501 = true
        severity_levels = {
            info = false,
            hint = false,
            warn = true,
            error = true },
        notify_options = {
            title = "LSP diagnostics",
            render = "minimal", -- "default", "minimal", "simple", "compact"
            animate = "static", -- "fade_in_slide_out", "fade", "slide", "static"
            timeout = false -- boolean, int
        },
        autocommands = { "BufEnter", "BufWritePre", "BufWritePost" }
    }

    -- local exclude_codes = {} -- e.g. E501
    --
    -- local severity_levels = {} -- info, hint, warn, error
    -- severity_levels["info"] = false
    -- severity_levels["hint"] = false
    -- severity_levels["warn"] = true
    -- severity_levels["error"] = true
    --
    -- local options = {
    --     title = "LSP diagnostics",
    --     render = "minimal", -- "default", "minimal", "simple", "compact"
    --     animate = "static", -- "fade_in_slide_out", "fade", "slide", "static"
    --     timeout = false -- boolean, int
    -- }
    --
    -- local autocommands = { "BufEnter", "BufWritePre", "BufWritePost" }
    --
    -- local config = {
    --     exclude_codes = exclude_codes,
    --     severity_levels = severity_levels,
    --     notify_options = options,
    --     autocommands = autocommands
    -- }

    return config
end

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.

local M = {}

M.init = function()
    if not vim.g.lspnotify_namespace then
        vim.g.lspnotify_namespace = vim.api.nvim_create_namespace "lspnotify"
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

    -- register options
    vim.g.lspnotify_config = options

    -- register autocommands
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

return M
