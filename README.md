# workspace-config.nvim

Project-specific Neovim configuration loader with automatic LSP setup.

## Features

- Load project-specific configuration from `.nvimrc.lua`
- Auto-install LSP servers via Mason
- Configure LSP servers with project-specific settings
- Configure DAP adapters and debug configurations
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
    'mfussenegger/nvim-dap', -- optional
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
      filetypes = { 'lua' },
      settings = {
        Lua = {
          diagnostics = { globals = {'vim'} }
        }
      }
    },
    rust_analyzer = {
      filetypes = { 'rust' },
      root_dir_patterns = { 'Cargo.toml' }
    },
    tsserver = {
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
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
   },
   dap_adapters = {
     codelldb = {
       type = 'server',
       port = '${port}',
       executable = {
         command = 'codelldb',
         args = {'--port', '${port}'},
       }
     },
   },
   dap_configs = {
     rust = {
       {
         name = 'Launch file',
         type = 'codelldb',
         request = 'launch',
         program = function()
           return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
         end,
         cwd = '${workspaceFolder}',
         stopOnEntry = false,
       },
     },
     python = {
       {
         type = 'python',
         request = 'launch',
         name = 'Launch file',
         program = '${file}',
         pythonPath = function()
           return '/usr/bin/python3'
         end,
       },
     },
   }
}
```

## Commands

- `:WorkspaceConfigReload` - Manually reload workspace configuration

## LSP Configuration Notes

For Neovim 0.11+, the `filetypes` field is **required** in each LSP server configuration. This tells the LSP which file types to activate on.

Example filetypes for common servers:
- `clangd`: `{ 'c', 'cpp', 'objc', 'objcpp' }`
- `pyright` or `pylsp`: `{ 'python' }`
- `rust_analyzer`: `{ 'rust' }`
- `gopls`: `{ 'go', 'gomod', 'gowork' }`
- `lua_ls`: `{ 'lua' }`

## Requirements

- Neovim 0.11+
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) (optional, for debugging support)

## License

MIT
