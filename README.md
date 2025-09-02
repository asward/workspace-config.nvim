# workspace-config.nvim

Project-specific Neovim configuration loader with automatic LSP setup.

## Features

- Load project-specific configuration from `.nvimrc.lua`
- Auto-install LSP servers via Mason
- Configure LSP servers with project-specific settings
- Auto-loads on startup or manual reload
- Auto-load filetype configuartion as autocommands

## Installation

### lazy.nvim
```lua
{
  'asward/workspace-config.nvim',
}
```

### packer.nvim
```lua
use {
  'asward/workspace-config.nvim',
  requires = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp', -- optional
  }
}
```

## Usage

Create a `.nvimrc.lua` file in your project root:

```lua
return {
  lsp_servers = { 'lua_ls', 'rust_analyzer', 'tsserver' },
  lsp_configs = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = {'vim'} }
        }
      }
    },
    rust_analyzer = {
      root_dir_patterns = { 'Cargo.toml' }
    }
  },
  filetype_configs = {
     python = {
       opts = {
         tabstop = 4,
         shiftwidth = 4,
         textwidth = 79,
       },
       keymaps = {
         { lhs = "<F5>", rhs = ":!python %<CR>" },
         { mode = "i", lhs = "<C-c>", rhs = "#", opts = { desc = "Insert comment" } },
       },
       commands = { "setlocal colorcolumn=80" },
       callback = function()
         print("Python file detected!")
       end,
     },
     lua = {
       opts = {
         tabstop = 2,
         shiftwidth = 2,
       },
       keymaps = {
         { lhs = "<F5>", rhs = ":luafile %<CR>" },
       },
     },
   }
}
```

## Commands

- `:WorkspaceConfigReload` - Manually reload workspace configuration

## Requirements

- Neovim 0.8+
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

## License

MIT
