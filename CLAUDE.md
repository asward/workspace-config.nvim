# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

workspace-config.nvim is a Neovim plugin that loads project-specific configuration from `.nvimrc.lua` files. It provides automatic LSP server installation via Mason, project-specific LSP configuration, and filetype-specific settings.

## Architecture

The plugin consists of two main Lua modules:

- `lua/workspace-config/init.lua` - Main plugin logic with three core functions:
  - `load_filetype_config()` - Sets up FileType autocmds for buffer-local options, keymaps, commands, and callbacks
  - `load_lsp_servers()` - Auto-installs LSP servers via Mason
  - `configure_lsp()` - Sets up LSP servers with project-specific configurations using nvim-lspconfig
- `lua/workspace-config/config.lua` - Empty configuration file

The plugin automatically loads `.nvimrc.lua` files from project roots and applies the configuration on startup.

## Development Commands

This is a Neovim plugin written in Lua. There are no build, test, or lint commands - development is done by:

1. Testing the plugin in a Neovim instance with the plugin installed
2. Creating test `.nvimrc.lua` files in project directories
3. Using `:WorkspaceConfigReload` command to reload configuration during development

## Key Dependencies

- mason.nvim - For automatic LSP server installation
- nvim-lspconfig - For LSP server configuration
- cmp-nvim-lsp - Optional, for LSP completion capabilities

## Configuration Format

The plugin expects `.nvimrc.lua` files to return a table with these optional keys:
- `lsp_servers` - Array of LSP server names to auto-install
- `lsp_configs` - Table of server-specific LSP configurations
- `filetype_configs` - Table of filetype-specific settings (opts, keymaps, commands, callback)

## Testing

Test the plugin by:
1. Installing it in a Neovim setup with the required dependencies
2. Creating a `.nvimrc.lua` file in a project directory
3. Opening Neovim in that directory and verifying the configuration loads
4. Using `:WorkspaceConfigReload` to test configuration changes