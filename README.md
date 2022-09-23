<h1 align="center">
workspaces.nvim
</h1>

<p align="center">A <i>discrete</i> 💅 tab manager for neovim

![2022-09-17(tabbing nvim)](https://user-images.githubusercontent.com/64455469/190948158-b99a7e24-9015-4c3b-94c8-954b690546db.gif)

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements

- Neovim 0.7+
- bufferline.nvim from akinsho

## Installation

**Lua**

```lua
-- using packer.nvim
use {'daricoder/tabbing.nvim', requires = ' akinsho/bufferline.nvim'}
```

## Usage
**Lua**

```lua
vim.opt.termguicolors = true
require("tabbing").setup{}
```

