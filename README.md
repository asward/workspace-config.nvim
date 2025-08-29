# workspace-config.nvim

Project-specific Neovim configuration loader with automatic LSP setup.

## Features

- Load project-specific configuration from `.nvimrc.lua`
- Auto-install LSP servers via Mason
- Configure LSP servers with project-specific settings
- Auto-loads on startup or manual reload

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
