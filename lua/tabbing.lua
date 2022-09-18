local M = {}
local Mivar = {}
local tab_previous = nil
local make_buf_listed_and_unlisted = function()

    local current_tab = vim.fn.tabpagenr()
    local max_tabs = vim.fn.tabpagenr('$')
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
                exist = true

            end

            -- if tab ~= current_tab  then
            --     vim.fn.setbufvar(buf, '&buflisted', 0)
            -- end
        end
        if not exist then vim.fn.setbufvar(buf, '&buflisted', 0) end
    end

end


local close_buffers = function()
    -- print('preioux' .. tab_previous)
    local current_tab = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr('$')

    -- local deleted_tab = vim.fn.tabpagenr() + 1
    for buf, tabs in pairs(Mivar) do
        print('comienzo iteracion')
        for tab, bool in pairs(tabs) do
            print('buf: ' ..
                buf .. ' tab: ' .. tab .. ' previoustab: ' .. tab_previous .. ' current_tab: ' .. current_tab)
            if tab == tab_previous then
                print('tab == tabprevious')
                Mivar[buf][tab] = nil
                vim.api.nvim_buf_delete(buf, { force = true })
            end
            if tab > tab_previous then
                print('tab > tabprevious')
                Mivar[buf][tab] = Mivar[buf][tab] - 1
            end
        end
        print('termino iteracion')


    end
end

local make_buf_listed = function()

    for buf, tabs in pairs(Mivar) do
        vim.fn.setbufvar(buf, '&buflisted', 1)
    end
end



local group = vim.api.nvim_create_augroup('puta', { clear = false })

function M.setup(conf)

    vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete", "WinEnter", "WinLeave", "TabLeave", "TabClosed" }, {
        group = group,
        pattern = '*',
        nested = true,
        callback = function(data)
            local tab = vim.fn.tabpagenr()
            local buf = data.buf
            local event = data.event

            if vim.fn.buflisted(buf) == 0 then return end

            print(event .. " buf: " .. data.buf .. " tab: " .. tab)

            if event == "BufEnter" then
                -- print('entro a bufenter')
                --
                if (Mivar[buf] == nil) then
                    Mivar[buf] = {}
                end
                -- si no existe
                if Mivar[buf][tab] == nil then
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


            if event == "BufDelete" then
                -- print('entro a bufDelete')
                Mivar[buf][tab] = nil
                -- Mivar[buf] = nil
                -- make_buf_listed_and_unlisted()
            end

            -- if event == "TabEnter" then
            --     -- print('entro TabEnter')
            --     make_buf_listed_and_unlisted()
            -- end


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

return M
