<h1 align="center">
workspaces.nvim
</h1>

<p align="center">Discrete 🌌 <i>Workspaces</i> 🌌 for Neovim tabs

<!-- ![workspaces](https://user-images.githubusercontent.com/64455469/192165473-c405ffa6-109c-4352-a43d-6406b4d313ad.gif) -->
## Preview

<br>
<table cellspacing="0" cellpadding="0">
    <thead>
        <tr>
            <th colspan="2">
                Named Workspaces
             </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="width=70%;padding:0;margin:0">
                <img src="https://user-images.githubusercontent.com/64455469/195036820-aeecbf0e-e38c-46f6-9a99-cda1ff76990c.gif" />
            </td>
            <td style="padding:0;margin:0">
                <img src="https://user-images.githubusercontent.com/64455469/195036762-d466161e-9a47-4a71-86b6-172f99e09d5c.gif" />
            </td>
        </tr>
    </tbody>
</table>
<br>
<table >
    <thead>
        <tr>
            <th >
               True Scopping
             </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td >
                <img src="https://user-images.githubusercontent.com/64455469/195036867-d7e54046-f210-473c-bea0-17c74168c34b.gif" />
            </td>
        </tr>
    </tbody>
</table>
<br>
<table >
    <thead>
        <tr>
             <th >
                Lsp Support
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td >
                <img src="https://user-images.githubusercontent.com/64455469/195036886-4239803f-d5bc-4b50-8b0b-acd1b88b5eb3.gif" />
            </td>
        </tr>
    </tbody>
</table>
and more...
<br>

<!-- | [workspaces_named]<img src="https://raw.githubusercontent.com/lewis6991/media/main/gitsigns_actions.gif" width="450em"/> | <img src="https://raw.githubusercontent.com/lewis6991/media/main/gitsigns_blame.gif" width="450em"/> | -->


## Table Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements
- Neovim 0.7+
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
<!-- - bufferline from akinsho ([see bufferline.nvim](https://github.com/akinsho/bufferline.nvim)) -->

## Installation

**Lua**

```lua
-- using packer.nvim
use {'daricoder/workspaces.nvim'}
```

## Usage
**Lua**

```lua
vim.opt.termguicolors = true
require("workspaces.nvim").setup{}
```

