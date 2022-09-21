local M = {}
local Mivar = {}
local tab_previous = nil
local make_buf_listed_and_unlisted = function()

    local current_tab = vim.fn.tabpagenr()
    local max_tabs = vim.fn.tabpagenr('$')
    -- local count_buffers_in_current_tab = 0
    -- local count_nonamemodified_buffers_in_current_tab = 0
    -- local nonamedmodifiedbuffer = nil
    for buf, tabs in pairs(Mivar) do
        local exist = false
        for tab, bool in pairs(tabs) do

            -- if tab > max_tabs then
            --     Mivar[buf] = nil
            --     vim.api.nvim_buf_delete(buf, {force = true})
            -- print('current tab:' ..
            --     current_tab .. ' current win:' .. vim.api.nvim_get_current_win() .. ' buf:' .. buf .. ' tab:' .. tab,
            --     ' wins:' .. vim.inspect(vim.fn.getbufinfo(buf)[1]['windows']))
            if tab == current_tab then
                -- print('tab actual igual a tab memoria')
                -- if vim.fn.getbufinfo(buf)[1]['windows'][2] == nil then
                --     print('buffer tiene solo una ventana')
                --     vim.fn.setbufvar(buf, '&buflisted', 0)
                -- else
                --     print('buffer tiene mas de una ventana')
                --     vim.fn.setbufvar(buf, '&buflisted', 1)
                -- end

                -- vim.fn.setbufvar(buf, '&buflisted', 0)
                -- break
                -- print('hola hola')
                -- print(vim.inspect(vim.fn.getbufinfo('%')[1]['name']))
                -- print(vim.inspect(vim.fn.getbufinfo('%')[1]['changed']))
                -- local bufinfo = vim.fn.getbufinfo('%')[1]
                -- if bufinfo['name'] == '' and bufinfo['changed'] == 0 then
                --     count_nonamemodified_buffers_in_current_tab = count_nonamemodified_buffers_in_current_tab + 1
                --     nonamedmodifiedbuffer = buf
                -- end
                exist = true
                -- count_buffers_in_current_tab = count_buffers_in_current_tab + 1

            end

            -- if tab ~= current_tab  then
            --     vim.fn.setbufvar(buf, '&buflisted', 0)
            -- end
        end
        if not exist then vim.fn.setbufvar(buf, '&buflisted', 0) end
    end
    -- print(count_buffers_in_current_tab, count_nonamemodified_buffers_in_current_tab)
    -- if current_tab > 1 and count_buffers_in_current_tab ~= 0 and count_nonamemodified_buffers_in_current_tab ~= 0 then
    --     vim.api.nvim_buf_delete(nonamedmodifiedbuffer,{force = true})
    -- end

end


local close_buffers = function()
    -- print('preioux' .. tab_previous)
    local current_tab = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr('$')

    -- local deleted_tab = vim.fn.tabpagenr() + 1
    for buf, tabs in pairs(Mivar) do
        -- print('comienzo iteracion')
        local buf_exist = 0
        for tab, bool in pairs(tabs) do
            buf_exist = buf_exist + 1
            -- print('buf: ' ..
            --     buf .. ' tab: ' .. tab .. ' previoustab: ' .. tab_previous .. ' current_tab: ' .. current_tab)
            if tab == tab_previous then
                -- print('tab == tabprevious')
                Mivar[buf][tab] = nil
                buf_exist = buf_exist - 1
                -- vim.api.nvim_buf_delete(buf, { force = true })
            end
            if tab > tab_previous then
                -- print('tab > tabprevious')
                Mivar[buf][tab] = nil
                Mivar[buf][tab - 1] = true
            end
        end
        if buf_exist == 0 then
            -- print('eliminando buffer de tabbing y de buffers!')
            Mivar[buf] = nil
            vim.fn.setbufvar(buf, '&buflisted', 0)
            vim.api.nvim_buf_delete(buf, { force = true })
        end
        -- print('termino iteracion')


    end
end

local make_buf_listed = function()

    for buf, tabs in pairs(Mivar) do
        vim.fn.setbufvar(buf, '&buflisted', 1)
    end
end

local tab_created = function()

    local current_tab = vim.fn.tabpagenr()
    for buf, tabs in pairs(Mivar) do
        for tab, bool in pairs(tabs) do

            -- print('buf: ' ..
            --     buf .. ' tab: ' .. tab .. ' previoustab: ' .. tab_previous .. ' current_tab: ' .. current_tab)
            if tab >= current_tab then
                -- print('tab >= tabprevious... haciendo tab+1')
                Mivar[buf][tab] = nil
                Mivar[buf][tab + 1] = true
            end
        end
    end
end

local check_noname = function()

    local current_tab = vim.fn.tabpagenr()
    for buf, tabs in pairs(Mivar) do
        for tab, bool in pairs(tabs) do

            print('buf: ' ..
                buf .. ' tab: ' .. tab .. ' previoustab: ' .. tab_previous .. ' current_tab: ' .. current_tab)
            if tab == current_tab then
                print('tab >= tabprevious... haciendo tab+1')
                Mivar[buf][tab] = nil
                Mivar[buf][tab + 1] = true
            end
        end
    end
end


local group = vim.api.nvim_create_augroup('puta', { clear = false })

function M.setup(conf)

    vim.api.nvim_create_autocmd({ "BufNew", "BufEnter", "WinEnter", "WinLeave", "TabNew", "TabLeave", "TabClosed" }, {
        group = group,
        pattern = '*',
        nested = true,
        callback = function(data)
            local tab = vim.fn.tabpagenr()
            local buf = data.buf
            local event = data.event

            if vim.fn.buflisted(buf) == 0 then

                local buftype = vim.fn.getbufvar(data.buf, 'floaterm_wintype')
                if buftype == 'split' or buftype == 'vsplit' then
                    if (Mivar[buf] == nil) then
                        Mivar[buf] = {}
                    end
                    -- si no existe
                    if Mivar[buf][tab] == nil then
                        Mivar[buf][tab] = true
                    end
                elseif event ~= 'TabNew' then
                    return
                end
            end

            -- print(event .. " buf: " .. data.buf .. " tab: " .. tab)

            if event == "BufEnter" then
                -- print('entro a bufenter')
                --
                -- si aun no tiene ningun registro
                if (Mivar[buf] == nil) then
                    Mivar[buf] = {}
                end
                -- si no existe tab para este buffer
                if Mivar[buf][tab] == nil then


                    local current_tab = vim.fn.tabpagenr()
                    local buffer_empty = nil
                    local count = 0
                    for bufx, tabs in pairs(Mivar) do
                        for tab, bool in pairs(tabs) do
                            if tab == current_tab then
                                count = count + 1
                                local bufinfo = vim.fn.getbufinfo(bufx)[1]
                                if bufinfo['name'] == '' and bufinfo['changed'] == 0 then
                                    -- print('encontre uno vacio', bufx)
                                    buffer_empty = bufx
                                end
                            end
                        end
                    end
                    -- print(buffer_empty, count)
                    if count == 1 and buffer_empty then
                        vim.api.nvim_buf_delete(buffer_empty, { force = true })
                        Mivar[buffer_empty] = nil
                    end
                    Mivar[buf][tab] = true
                end
                -- Mivar[buf] = tab
                make_buf_listed_and_unlisted()
            end
            if event == "WinEnter" then
                -- vim.cmd [[
                --     e new
                --     bwipeout new
                -- ]]
                -- if tab_previous then
                --
                --     vim.cmd [[
                --         new
                --         echom "wipeout"
                --         bwipeout
                --     ]]
                -- end

                make_buf_listed_and_unlisted()
            end


            -- if event == "BufDelete" then
            --     -- print('entro a bufDelete')
            --     -- Mivar[buf][tab] = nil
            --     -- Mivar[buf] = nil
            --     -- make_buf_listed_and_unlisted()
            -- end

            if event == "TabNew" then
                -- print('entro TabEnter')
                tab_created()
            end


            if event == "TabLeave" then
                -- print('entro TabLeave')
                -- vim.api.nvim_create_buf(true, false)
                tab_previous = vim.fn.tabpagenr()
                -- vim.cmd [[
                -- echom "new window with empty no name"
                -- new
                -- ]]
                -- vim.fn.new()
                -- vim.api.nvim_buf_delete(0, {force = true})
                make_buf_listed()
            end

            if event == "TabClosed" then
                -- print('entro TabClosed')
                -- make_buf_listed_and_unlisted()
                close_buffers()
            end


            -- print(vim.inspect(Mivar))
        end
    })

end

vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = "FloatermOpen",
    callback = function(data)
        -- print('FloatermOpen')
        -- print(data.buf)
        -- -- local buftype = vim.
        -- local buftype = vim.fn.getbufvar(data.buf, 'floaterm_wintype')
        -- print('type: ' .. buftype)
        -- if buftype ~= 'float' then vim.fn.setbufvar(data.buf, '&buflisted', 1) end
    end
})


return M
