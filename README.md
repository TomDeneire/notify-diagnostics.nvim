# lsp-notify

## Concept

`lsp-notify` is a Neovim plugin that displays LSP diagnostics with [nvim-notify](...).

It's functionality and appearence are configurable:

- You can configure which diagnostics are displayed (e.g. only errors) and/or exclude certain error codes (e.g. E501 - line too long).
- You can determine which actions (e.g. `BufPostWrite`) trigger a refresh of the notification.
- You can choose the style of the notification (e.g. minimal), including the notification title.

**This plugin is currently in its alpha stage, so please let me know if you experience any issues!**

## Installation

using VimPlug

using Packer

dependencies nvim-notify!

## Setup

Include the following in your setup:

``` lua
require("lsp-notify").setup()
```

`lsp-notify` comes with the following defaults, which you can alter during setup:

``` lua
    {
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
            timeout = false -- boolean, int
        },
        autocommands = { "BufEnter", "BufWritePre", "BufWritePost" }
    }
```

Motivation

Diagnostics out of bounds (example) notify diagnostics handles linebreaks 

You can set timeout 

Relationship to lsp notify (does not display diagnostics)

Also, it is advisable to disable virtual text (although you can keep it if you want):


``` lua
vim.diagnostic.config({ virtual_text = false })
```

Be advised that when first opening a file, notify-diagnostics can only start working once LSP have finished loading.

That's why they are only displayed after the first save.

to do:
- github version
- perhaps also styling can be set in options
