" Title:        notify-lsp-diagnostics
" Description:  A plugin to display LSP diagnostics with nvim-notify
" Last Change:  16 February 2023
" Maintainer:   Tom Deneire <https://github.com/tomdeneire>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_lspnotify")
    finish
endif
let g:loaded_lspnotify = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/lsp-notify/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 Notifylspdiagnostics lua require("lsp-notify").diagnostics()
