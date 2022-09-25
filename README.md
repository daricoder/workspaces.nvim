<h1 align="center">
workspaces.nvim
</h1>

<p align="center">A <i>discrete</i> 💅 tab manager for neovim

![workspaces](https://user-images.githubusercontent.com/64455469/192165473-c405ffa6-109c-4352-a43d-6406b4d313ad.gif)

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements
[nerd fonts](https://github.com/ryanoasis/nerd-fonts))
- Neovim 0.7+
- bufferline from akinsho [see bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

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

