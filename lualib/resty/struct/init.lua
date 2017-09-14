local s = require 'resty.struct.type'
local buffer = require 'resty.struct.buffer'

local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function (narr, nrec) return {} end
end

local _M = new_tab(0, 4)

_M._VERSION = '0.0.1'

function _M.pack(format, ...)
    local args = {...}
    local buff = buffer:new()
    local endian
    local args_index = 1
    for i = 1, #format do
        local case = format:sub(i, i)
        if '@' == case or '=' == case then
            -- native endian
            endian = nil
        elseif '<' == case then
            -- little endian
            endian = 'le'
        elseif '>' == case or '!' == case then
            -- network/big endian
            endian = 'be'
        elseif 'c' == case then
            -- char
            local char = (args[args_index]):sub(1, 1)
            buff:append(data)
            args_index = args_index + 1
        elseif 'b' == case then
            -- signed char
            local char = (args[args_index]):byte(1)
            local data = s.set_int(char, 1)
            buff:append(data)
            args_index = args_index + 1
        elseif 'B' == case then
            -- unsigned char
            local char = (args[args_index]):byte(1)
            local data = s.set_uint(char, 1)
            buff:append(data)
            args_index = args_index + 1
        elseif '?' == case then
            -- _Bool
            local flag = args[args_index] and 1 or 0
            local data = s.set_uint(flag, 1)
            buff:append(data)
            args_index = args_index + 1
        elseif 'h' == case then
            -- short
            local data = s.set_int(args[args_index], 2, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'H' == case then
            -- unsigned short
            local data = s.set_uint(args[args_index], 2, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'i' == case then
            -- int
            local data = s.set_int(args[args_index], 4, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'I' == case then
            -- unsigned int
            local data = s.set_uint(args[args_index], 4, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'l' == case then
            -- long
            local data = s.set_int(args[args_index], 4, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'L' == case then
            -- unsigned long
            local data = s.set_uint(args[args_index], 4, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'q' == case then
            -- long long
            local data = s.set_int(args[args_index], 8, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'Q' == case then
            -- unsigned long long
            local data = s.set_uint(args[args_index], 8, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'f' == case then
            -- float
            local data = s.set_float(args[args_index], 4, endian)
            buff:append(data)
            args_index = args_index + 1
        elseif 'd' == case then
            -- double
            local data = s.set_float(args[args_index], 8, endian)
            buff:append(data)
            args_index = args_index + 1
        else
            return nil, ("format '%s' at pos %d not support"):format(case, i)
        end
    end
    return buff:getall()
end

function _M.unpack(format, string)
    local t = {}
    local t_index = 1
    local buff = buffer:new()
    buff:set(string)
    local endian
    for i = 1, #format do
        local case = format:sub(i, i)
        if '@' == case or '=' == case then
            -- native endian
            endian = nil
        elseif '<' == case then
            -- little endian
            endian = 'le'
        elseif '>' == case or '!' == case then
            -- network/big endian
            endian = 'be'
        elseif 'c' == case then
            -- char
            t[t_index] = buff:get(1)
            t_index = t_index + 1
        elseif 'b' == case then
            -- signed char
            local data = buff:get(1)
            t[t_index] = s.get_int(data)
            t_index = t_index + 1
        elseif 'B' == case then
            -- unsigned char
            local data = buff:get(1)
            t[t_index] = s.get_uint(data)
            t_index = t_index + 1
        elseif '?' == case then
            -- _Bool
            local data = buff:get(1)
            if 0 == s.get_int(data) then
                t[t_index] = false
            else
                t[t_index] = true
            end
            t_index = t_index + 1
        elseif 'h' == case then
            -- short
            local data = buff:get(2)
            t[t_index] = s.get_int(data, endian)
            t_index = t_index + 1
        elseif 'H' == case then
            -- unsigned short
            local data = buff:get(2)
            t[t_index] = s.get_uint(data, endian)
            t_index = t_index + 1
        elseif 'i' == case then
            -- int
            local data = buff:get(4)
            t[t_index] = s.get_int(data, endian)
            t_index = t_index + 1
        elseif 'I' == case then
            -- unsigned int
            local data = buff:get(4)
            t[t_index] = s.get_uint(data, endian)
            t_index = t_index + 1
        elseif 'l' == case then
            -- long
            local data = buff:get(4)
            t[t_index] = s.get_int(data, endian)
            t_index = t_index + 1
        elseif 'L' == case then
            -- unsigned long
            local data = buff:get(4)
            t[t_index] = s.get_uint(data, endian)
            t_index = t_index + 1
        elseif 'q' == case then
            -- long long
            local data = buff:get(8)
            t[t_index] = s.get_int(data, endian)
            t_index = t_index + 1
        elseif 'Q' == case then
            -- unsigned long long
            local data = buff:get(8)
            t[t_index] = s.get_uint(data, endian)
            t_index = t_index + 1
        elseif 'f' == case then
            -- float
            local data = buff:get(4)
            t[t_index] = s.get_float(data, endian)
            t_index = t_index + 1
        elseif 'd' == case then
            -- double
            local data = buff:get(8)
            t[t_index] = s.get_float(data, endian)
            t_index = t_index + 1
        else
            return nil, ("format '%s' at pos %d not support"):format(case, i)
        end
    end
    return t, t_index - 1
end

function _M.calcsize(format)
    local count = 0
    for i = 1, #format do
        local case = format:sub(i, i)
        if ('@=<>!'):find(case) then
        elseif ('cbB?'):find(case) then
            count = count + 1
        elseif ('hH'):find(case) then
            count = count + 2
        elseif ('iIlLf'):find(case) then
            count = count + 4
        elseif ('qQd'):find(case) then
            count = count + 8
        else
            return nil, ("format '%s' at pos %d not support"):format(case, i)
        end
    end
    return count
end

return _M
