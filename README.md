<h1 align="center">
tabbing.nvim
</h1>

<p align="center">A <i>discrete</i> 💅 tab manager for neovim

![2022-09-17 23-03-24(tabbing nvim)](https://user-images.githubusercontent.com/64455469/190886110-5191e56e-0272-4103-a502-2069498f038e.gif)

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

