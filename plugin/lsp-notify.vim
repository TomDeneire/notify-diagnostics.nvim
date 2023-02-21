" Title:        notify-diagnostics
" Description:  A plugin to display LSP diagnostics with nvim-notify
" Last Change:  17 February 2023
" Maintainer:   Tom Deneire <https://github.com/tomdeneire>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_notifydiagnostics")
    finish
endif
let g:loaded_notifydiagnostics = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/notify-diagnostics/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 Notifylspdiagnostics lua require("notify-diagnostics").diagnostics()
command! -nargs=0 Notifylspenable lua require("notify-diagnostics").enable()
command! -nargs=0 Notifylspdisable lua require("notify-diagnostics").disable()
