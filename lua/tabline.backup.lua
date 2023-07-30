globalx = function()
    print('hola a todos')
end

vim.cmd [[
hi TabLine guibg=NONE gui=NONE
hi TabLineFill guibg=NONE gui=NONE
hi TabLineSel guibg=NONE gui=NONE
hi! link Tabline LineNr
hi! link TablineSel Special


function SwitchBuffer(minwid, nclicks, button, mod)
    " echom "hola puto"
    " echom a:minwid
    " echom type(a:minwid)
    " echom a:nclicks
    " echom a:button
    " " echom a:mod
    execute "buffer ". a:minwid

endfunction


function MyTabLabel2(n)
      let buflist = tabpagebuflist(a:n)
      let winnr = tabpagewinnr(a:n)
      let name = bufname(buflist[winnr - 1])
      if name == ''
          let name = 'no name'
      endif
      return name
endfunction


function MyTabLine2()
" buffers

let fileicons = {'lua': " ", 'javascript':" ", 'json':" ", "markdown":" ", "typescript":" ","python":" ","html":" "}

    let s = ''
    let buflist = getbufinfo()
    for i in buflist
      " select the highlighting
      " let s ..= '%#TabLineSel#'

      " set the tab page number (for mouse clicks)
      " let s ..= '%' .. i .. 'B'

      " the label is made by MyTabLabel()
      " let s ..= '%{MyTabLabel2(' .. (i + 1) .. ')} '
      if i['listed'] == 1

        " let windows = getbufinfo(i['bufnr'])
        " let windowstab = gettabinfo(tabpagenr())['windows']
        
        let bufs = tabpagebuflist()
        let bufname = '[No Name]'
        if i['name'] != ''
             let bufname = i['name']
        endif
        
        
        " let contador = 0
        " for w in windows
        "     if index(windowstab,  w) >= 0
        "         let contador = contador + 1 
        "     endif
        " endfor
        " if len(windowstab) != contador 
        "     let contador = -1
        " endif
       " if index(gettabinfo(tabpagenr())['windows'], )

        if i['hidden'] == 0 && index(bufs,i['bufnr']) >= 0
            if i['changed'] == 1
                let s ..= '%#Statement#'
            else
                let s ..= '%#TablineSel#'
            endif
        else
            let s ..= '%#Tabline#'
        endif
        
        "set icon and name tail buffer
        " let s ..= "\uf15c " .. fnamemodify(bufname,':t') 
        " let s ..= "\uf5ce " .. fnamemodify(bufname,':t') 
        let filetype = getbufvar(i['bufnr'],'&filetype')
        let fileicon = get(fileicons, filetype, " ")

        " let s ..= " " .. fnamemodify(bufname,':t') 
        " let s ..= '%10@SwitchBuffer@foo.c%X' .. fileicon .. fnamemodify(bufname,':t') 
        let s ..= '%'..i['bufnr']..'@SwitchBuffer@'.. fileicon .. fnamemodify(bufname,':t')..'%X'         
        "set icon modified 
        if i['changed'] == 1
            " let s ..= ' ' .. "\uf784"
            " let s ..= ' ' .. "\uf111"
            let s ..= ' ' .. "●"
        endif
        let s ..= '%#NonText# | '
      endif
    endfor

" tabs 
  let s ..= '%='
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
      " let s ..= '%#String#'
    else
      let s ..= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'
    " the label is made by MyTabLabel()
    "    let s ..= '%{MyTabLabel2(' .. (i + 1) .. ')} '
    " let s ..= " " .. "workspace" .. (i + 1) .. "" .. " "
    let s ..= " " .."" .. " "

    if tabpagenr('$') > 1
      let s ..= '%#NonText#|'
    endif
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s ..= ' %#TabLine#%999X' .. "\uf00d" .. "%999X "
  endif

  return s
endfunction
" set tabline=%!MyTabLine2()

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

myTabLine3 = function()
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


            -- set lsp indicators
            if #lsp_warns > 0 or #lsp_errors > 0 then
                lsp_indicators = lsp_indicators .. ' ['
            end
            if #lsp_warns > 0 then
                lsp_indicators = lsp_indicators ..
                    -- '%#' .. lsp_warn_group_color .. '#' .. #lsp_warns .. lsp_warn_icon .. ''
                    #lsp_warns .. '%#' .. lsp_warn_group_color .. '#' .. lsp_warn_icon .. ''
            end
            if #lsp_warns > 0 then
                lsp_indicators = lsp_indicators .. ' %#Statement#'
            end
            if #lsp_errors > 0 then
                lsp_indicators = lsp_indicators ..
                    -- '%#' .. lsp_error_group_color .. '#' .. #lsp_errors .. lsp_error_icon .. ''
                    #lsp_errors .. '%#' .. lsp_error_group_color .. '#' .. lsp_error_icon .. ''
            end
            if #lsp_warns > 0 or #lsp_errors > 0 then
                lsp_indicators = lsp_indicators .. '%#Statement#]'
            end
            if buffer['name'] ~= '' then
                bufname = buffer['name']
            end
            if buffer['hidden'] == 0 and bufs[buffer['bufnr']] ~= nil then

                if buffer['changed'] == 1 then
                    s = s .. '%#Statement#'
                else
                    s = s .. '%#TablineSel#'
                end
            else
                s = s .. '%#Tabline#'
            end


            local filetype = vim.bo[buffer['bufnr']].filetype
            local fileicon = fileicons[filetype] or " "
            s = s ..
                '%' ..
                -- buffer['bufnr'] .. "@SwitchBuffer@" .. fileicon .. vim.fn.fnamemodify(bufname, ':t') .. '%X'
                buffer['bufnr'] ..
                "@SwitchBuffer@" .. fileicon .. vim.fn.fnamemodify(bufname, ':t') .. lsp_indicators .. '%X'
            if buffer['changed'] == 1 then
                s = s .. '%#Statement# ' .. "●"
            end
            s = s .. '%#NonText# | '
        end
    end
    return s
end


vim.opt.tabline = "%!luaeval('myTabLine3()')"
