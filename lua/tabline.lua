local M = {}
vim.cmd [[

hi TabLine guibg=NONE gui=NONE
hi TabLineFill guibg=NONE gui=NONE
hi TabLineSel guibg=NONE gui=NONE
hi! link Tabline LineNr
hi! link TablineSel Special
hi prueba guibg=NONE guifg=#FFFFFF


function SwitchBuffer(minwid, nclicks, button, mod)
    " echom "hola puto"
    " echom a:minwid
    " echom type(a:minwid)
    " echom a:nclicks
    " echom a:button
    " " echom a:mod
    execute "buffer ". a:minwid

endfunction


]]

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

SwitchBuffer3 = function(minwid, nclicks, button, mod)
    -- " echom "hola puto"
    -- " echom a:minwid
    -- " echom type(a:minwid)
    -- " echom a:nclicks
    -- " echom a:button
    -- " " echom a:mod
    -- execute "buffer ". a:minwid
    print(minwid)
    print('hola')

end

M.myTabLine3 = function()
    local fileicons = { lua = " ", javascript = " ", json = " ", markdown = " ", typescript = " ",
        python = " ", html = " " }
    local s = ""
    local buflist = vim.fn.getbufinfo()
    for i, buffer in pairs(buflist) do
        if buffer['listed'] == 1 then
            local bufs = get_tabpagebuflist(0)
            local bufname = '[NO NAME]'
            local lsp_warns = vim.diagnostic.get(buffer['bufnr'], { severity = vim.diagnostic.severity.WARN })
            local lsp_errors = vim.diagnostic.get(buffer['bufnr'], { severity = vim.diagnostic.severity.ERROR })
            local lsp_indicators = ''
            -- local lsp_warn_icon = "💩"
            local lsp_warn_icon = ""
            -- local lsp_error_icon = "💀"
            local lsp_error_icon = "ﮊ"
            -- local lsp_warn_group_color = 'DiagnosticWarn'
            -- local lsp_error_group_color = 'DiagnosticError'
            local lsp_warn_group_color = 'Statement'
            local lsp_error_group_color = 'Statement'



            local filename_group_hl = ''
            if buffer['hidden'] == 0 and bufs[buffer['bufnr']] ~= nil then

                if buffer['changed'] == 1 then
                    -- s = s .. '%#Statement#'
                    filename_group_hl = "%#Statement#"
                else
                    -- s = s .. '%#TablineSel#'
                    filename_group_hl = "%#TablineSel#"
                end
            else
                -- s = s .. '%#Tabline#'
                filename_group_hl = "%#Tabline#"
            end


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
            if #lsp_warns > 0 then
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

            local filetype = vim.bo[buffer['bufnr']].filetype
            local fileicon = fileicons[filetype] or " "
            s = s .. filename_group_hl
                .. '%' .. buffer['bufnr'] .. "@SwitchBuffer@"
                .. fileicon
                .. vim.fn.fnamemodify(bufname, ':t')
                .. lsp_indicators ..
                '%X'
            if buffer['changed'] == 1 then
                -- s = s .. '%#Statement# ' .. "●"
                s = s .. " ●"
            end
            s = s .. '%#NonText# | '
        end
    end

    -- tabs
    s = s .. "%="
    for i = 1, vim.fn.tabpagenr('$'), 1 do
        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#Tabline#"
        end
        s = s .. "%" .. i .. 'T'
        s = s .. " " .. "" .. " "

        if vim.fn.tabpagenr('$') > 1 then
            s = s .. "%#NonText#|"
        end
    end
    s = s .. "%#TabLineFill#%T"

    if vim.fn.tabpagenr('$') > 1 then
        -- s = s .. "%#Tabline#%999X" .. '\uf00d'
        s = s .. ' %#TabLine#%999X' .. "" .. "%999X "
    end

    return s
end

return M
