# Neovim Desktop Configuration

Personal Neovim configuration for desktop development, built with Lua and [Lazy.nvim](https://github.com/folke/lazy.nvim).

## Overview

This repository contains my personal Neovim configuration for desktop development.

The configuration is organized into modular Lua files to make it easier to maintain, customize, and extend.

## Requirements

- [Neovim](https://neovim.io/)
- Git
- A terminal environment
- A [Nerd Font](https://www.nerdfonts.com/) (recommended for icons)

## Plugin Manager

This configuration uses [Lazy.nvim](https://github.com/folke/lazy.nvim) as its plugin manager.

Lazy.nvim is automatically bootstrapped through `init.lua`.

Plugin versions are tracked using `lazy-lock.json`.

## Directory Structure

```text
nvim/
├── init.lua
├── lazy-lock.json
├── .gitignore
└── lua/
    ├── config/
    │   ├── lsp/
    │   │   └── language/
    │   └── moduls/
    ├── core/
    ├── plugins/
    └── var/
```

### Configuration Modules

- `core/` — Core Neovim settings, options, keymaps, autocmds, and functions.
- `config/` — Plugin configuration and supporting modules.
- `config/lsp/` — Language Server Protocol configuration.
- `config/lsp/language/` — Language-specific LSP settings.
- `plugins/` — Plugin specifications managed by Lazy.nvim.
- `var/` — Shared variables and icon definitions.

## Installation

Clone this repository into the Neovim configuration directory:

```bash
git clone https://github.com/matobodol/nvim.git ~/.config/nvim
```

Then launch Neovim:

```bash
nvim
```

Lazy.nvim will automatically bootstrap itself and install the configured plugins.

## Updating

To update this configuration:

```bash
cd ~/.config/nvim
git pull
```

To synchronize plugin versions, open Neovim and run:

```vim
:Lazy sync
```

## License

This repository contains my personal Neovim configuration. You are welcome to explore it and adapt it to your own workflow.
