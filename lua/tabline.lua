local M = {}
M.name_workspaces = {}
local conf = require "workspaces".conf


vim.cmd [[
" hi TabLine guibg=NONE gui=NONE
" hi TabLineFill guibg=NONE gui=NONE
" hi TabLineSel guibg=NONE
" hi! link Tabline LineNr
" hi! link TablineSel Special
" hi link filenameSel PmenuSel
" hi! link filenameSel Special
hi filename guifg=black guibg=white
hi separatorSel guifg=white guibg=NONE

function SwitchBuffer(minwid, nclicks, button, mod)
    execute "buffer ". a:minwid
endfunction


]]
local get_color_from_hl = function(colorbg, colorfg)
    -- {
    --     background = "Normal"
    -- }
    -- {
    --     foreground = "PmenuSel"
    -- }
    local default_color = {
        background = "#FFFFFF",
        foreground = "#000000"
    }
    local attrbg = colorbg["background"] and "background" or "foreground"
    local attrfg = colorfg["background"] and "background" or "foreground"
    local namebg = colorbg[attrbg]
    local namefg = colorfg[attrfg]


    if not (attrbg and attrfg and namebg and namefg) then
        return default_color
    end



    local statusbg, bg = pcall(vim.api.nvim_get_hl_by_name, namebg, true)
    local statusfg, fg = pcall(vim.api.nvim_get_hl_by_name, namefg, true)


    if not (statusbg and statusfg) then
        return default_color
    end
    if bg[attrbg] == nil or fg[attrfg] == nil then
        return default_color
    end

    bg = string.format("#%06x", bg[attrbg])
    fg = string.format("#%06x", fg[attrfg])

    return {
        background = bg,
        foreground = fg
    }
end

local colorSel = conf and conf.colorSel or get_color_from_hl({ background = "Pmenusel" }, { foreground = "PmenuSel" })
local colorModif = conf and conf.colorModif or get_color_from_hl({ background = "IncSearch" }, { foreground = "IncSearch" })
local color = conf and conf.color or get_color_from_hl({ background = "Tabline" }, { foreground = "Tabline" })
vim.print(conf)


local colorWorkspaceModif = colors and colors.colorWorkspaceModif or get_color_from_hl({ background = "Pmenusel" }, { foreground = "Search" })

vim.api.nvim_set_hl(0, "tablineSeparatorFocus", { fg = colorSel.background })
vim.api.nvim_set_hl(0, "tablineFocus", { fg = colorSel.foreground, bg = colorSel.background })

vim.api.nvim_set_hl(0, "tablineSeparatorModified", { fg = colorModif.background })
vim.api.nvim_set_hl(0, "tablineModified", { fg = colorModif.foreground, bg = colorModif.background })

vim.api.nvim_set_hl(0, "tablineSeparatorUnfocus", { fg = color.background })
vim.api.nvim_set_hl(0, "tablineUnfocus", { fg = color.foreground, bg = color.background })


vim.api.nvim_set_hl(0, "tablineWorkspaceSeparatorLeftFocus", { fg = colorWorkspaceModif.background })
vim.api.nvim_set_hl(0, "tablineWorkspaceSeparatorLeftUnFocus", { fg = colorWorkspaceModif.foreground })

vim.api.nvim_set_hl(0, "tablineWorkspaceSeparatorRightFocus",
    { fg = colorWorkspaceModif.foreground, bg = colorWorkspaceModif.background })
vim.api.nvim_set_hl(0, "tablineWorkspaceSeparatorRightUnFocus",
    { fg = colorWorkspaceModif.background, bg = colorWorkspaceModif.foreground })
vim.api.nvim_set_hl(0, "tablineWorkspaceSeparator",
    { fg = colorWorkspaceModif.foreground, bg = colorWorkspaceModif.foreground })





local get_hl_from_buf = function(buffer, bufs, item)
    local filename_group_hl = nil
    item = item or "tab"
    if buffer['hidden'] == 0 and bufs[buffer['bufnr']] ~= nil then
        if buffer['changed'] == 1 then
            -- s = s .. '%#Statement#'
            if item == "tab" then
                filename_group_hl = "%#tablineModified#"
            else
                filename_group_hl = "%#tablineSeparatorModified#"
            end
        else
            if item == "tab" then
                filename_group_hl = "%#tablineFocus#"
            else
                filename_group_hl = "%#tablineSeparatorFocus#"
            end
        end
    else
        -- s = s .. '%#Tabline#'
        if item == "tab" then
            filename_group_hl = "%#tablineUnfocus#"
        else
            filename_group_hl = "%#tablineSeparatorUnfocus#"
        end
    end
    return filename_group_hl
end
local get_tabpagebuflist = function(tabpage)
    tabpage = tabpage or 0
    local wins = vim.api.nvim_tabpage_list_wins(tabpage)
    local bufs = {}
    for i, win in pairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buflisted then
            -- bufs[win] = buf
            bufs[buf] = win
        end
    end
    return bufs
end

-- SwitchBuffer3 = function(minwid, nclicks, button, mod)
--     -- " echom "hola puto"
--     -- " echom a:minwid
--     -- " echom type(a:minwid)
--     -- " echom a:nclicks
--     -- " echom a:button
--     -- " " echom a:mod
--     -- execute "buffer ". a:minwid
-- end

M.myTabLine3 = function(conf)

    local fileicons = {
        lua = " ",
        javascript = " ",
        json = " ",
        markdown = " ",
        typescript = " ",
        python = " ",
        html = " "
    }
    local s = ""
    local buflist = vim.fn.getbufinfo({ buflisted = true })
    local current_buffer = vim.fn.bufnr()
    for i, buffer in pairs(buflist) do
        local bufs = get_tabpagebuflist(0)
        local bufname = '[NO NAME]'
        local lsp_warns = vim.diagnostic.get(buffer['bufnr'], { severity = vim.diagnostic.severity.WARN })
        local lsp_errors = vim.diagnostic.get(buffer['bufnr'], { severity = vim.diagnostic.severity.ERROR })
        local lsp_indicators = ''
        local lsp_warn_icon = ""
        local lsp_error_icon = "ﮊ"
        local lsp_warn_group_color = 'Statement'
        local lsp_error_group_color = 'Statement'



        local filename_group_hl = get_hl_from_buf(buffer, bufs)

        -- set lsp indicators
        if #lsp_warns > 0 or #lsp_errors > 0 then
            lsp_indicators = lsp_indicators .. ' ['
        end
        if #lsp_warns > 0 then
            lsp_indicators = lsp_indicators ..
                -- '%#' .. lsp_warn_group_color .. '#' .. #lsp_warns .. lsp_warn_icon .. ''
                #lsp_warns .. filename_group_hl .. lsp_warn_icon .. ''
        end
        --  if some warns exists
        if #lsp_warns > 0 and #lsp_errors > 0 then
            lsp_indicators = lsp_indicators .. ' '
        end
        -- if some errors exists
        if #lsp_errors > 0 then
            lsp_indicators = lsp_indicators ..
                -- '%#' .. lsp_error_group_color .. '#' .. #lsp_errors .. lsp_error_icon .. ''
                #lsp_errors .. filename_group_hl .. lsp_error_icon .. ''
        end
        -- if some warn or error exist
        if #lsp_warns > 0 or #lsp_errors > 0 then
            lsp_indicators = lsp_indicators .. filename_group_hl .. ']'
        end
        if buffer['name'] ~= '' then
            bufname = buffer['name']
        end
        -- --------
        local separator_init_buf = ''
        local separator_final_buf = ''
        -- separador izquierdo siempre va y se configura el hl para colorizarlo cuando tenga el foco
        -- -- este es el importante
        -- -- ya que se verifica que si el buffer anterior es el foco entonces se le aplica el highligh
        -- local before_buffer = buflist[i - 1] and buflist[i - 1]['bufnr']
        -- if buflist[i - 1] and buflist[i - 1]['listed'] == 1 then
        --     before_buffer = buflist[i - 1]
        -- end

        separator_grouphl = get_hl_from_buf(buffer, bufs, "separator")
        -- if buffer['hidden'] ~= 0 then
        --     separator_init_buf = "╱"
        --     separator_final_buf = "╲"
        -- end


        -- local separator_buf_init = ''
        local filetype = vim.bo[buffer['bufnr']].filetype
        local fileicon = fileicons[filetype] or " "

        s = s .. separator_grouphl .. separator_init_buf .. filename_group_hl
            .. '%' .. buffer['bufnr'] .. "@SwitchBuffer@"
            .. " " .. fileicon
            .. vim.fn.fnamemodify(bufname, ':t')
            .. lsp_indicators
            .. '%X'
        if buffer['changed'] == 1 then
            s = s .. " ●"
        end
        s = s .. " " .. separator_grouphl .. separator_final_buf
    end

    -- tabs
    tab_grouphl = ""
    separatorLeft_grouphl = ""
    separatorRight_grouphl = ""
    separatorLeft = ""
    separatorRight = ""
    s = s .. "%="
    for i = 1, vim.fn.tabpagenr('$'), 1 do
        if i == vim.fn.tabpagenr() then
            tab_grouphl = "%#tablineWorkspaceSeparatorRightFocus#"
        else
            tab_grouphl = "%#tablineWorkspaceSeparatorRightUnFocus#"
        end

        if i == 1 then
            separatorLeft_grouphl = "%#tablineWorkspaceSeparatorLeftFocus#"
            separatorRight_grouphl = "%#tablineWorkspaceSeparatorLeftFocus#"
            separatorLeft = ""
            separatorRight = ""
            if i ~= vim.fn.tabpagenr('$') then
                if i + 1 == vim.fn.tabpagenr() then
                    separatorLeft_grouphl = "%#tablineWorkspaceSeparatorLeftUnFocus#"
                    separatorRight_grouphl = "%#tablineWorkspaceSeparatorRightFocus#"
                elseif i ~= vim.fn.tabpagenr() then
                    separatorLeft_grouphl = "%#tablineWorkspaceSeparatorLeftUnFocus#"
                    separatorRight_grouphl = "%#tablineWorkspaceSeparator#"
                elseif i == vim.fn.tabpagenr() then
                    separatorRight_grouphl = "%#tablineWorkspaceSeparatorRightUnFocus#"
                end
            end
        elseif i == vim.fn.tabpagenr('$') then
            separatorLeft_grouphl = ""
            separatorRight_grouphl = "%#tablineWorkspaceSeparatorLeftFocus#"
            separatorLeft = ""
            separatorRight = ""
            if i ~= vim.fn.tabpagenr() then
                separatorRight_grouphl = "%#tablineWorkspaceSeparatorLeftUnFocus#"
            end
        else
            separatorLeft_grouphl = ""
            separatorRight_grouphl = "%#tablineWorkspaceSeparatorRightUnFocus#"
            separatorLeft = ""
            separatorRight = ""
            if i + 1 == vim.fn.tabpagenr() then
                separatorRight_grouphl = "%#tablineWorkspaceSeparatorRightFocus#"
            elseif i ~= vim.fn.tabpagenr() then
                separatorRight_grouphl = "%#tablineWorkspaceSeparator#"
            end
        end



        local name_workspace = M.name_workspaces[i] or i
        s = s .. "%" .. i .. 'T'
        -- s = s .. " " .. "" .. " "
        s = s ..
            separatorLeft_grouphl .. separatorLeft ..
            tab_grouphl .. " " .. name_workspace .. " " ..
            separatorRight_grouphl .. separatorRight





        if vim.fn.tabpagenr('$') > 1 then
            -- s = s .. "%#NonText#|"
        end
    end
    s = s .. "%#TabLineFill#%T"

    if vim.fn.tabpagenr('$') > 1 then
        -- s = s .. "%#Tabline#%999X" .. '\uf00d'
        s = s .. '%#tablineWorkspaceSeparatorLeftFocus#%999X' .. " " .. "%999X "
    end

    return s
end
local RenameWorkspace = function()
    local current_tab = vim.fn.tabpagenr()
    local current_workspace = M.name_workspaces[current_tab] or current_tab

    local status, renamed_workspace = pcall(vim.fn.input, 'Rename ' .. current_workspace .. ' to:')

    if (not status) then return end

    -- local renamed_workspace = vim.fn.input('Rename ' .. current_workspace .. ' to:')


    -- local answer = vim.fn.confirm('Workpace' .. current_workspace .. ' to ' .. renamed_workspace, "&Yes\n&No", 1)
    -- if answer == 1 then
    --     M.name_workspaces[current_tab] = renamed_workspace
    --     vim.api.nvim_command('redraw!')
    -- end

    if renamed_workspace ~= '' then
        M.name_workspaces[current_tab] = renamed_workspace
        vim.api.nvim_command('redraw!')
    end
end


vim.keymap.set({ 'n', }, '<A-m>', RenameWorkspace)
return M
