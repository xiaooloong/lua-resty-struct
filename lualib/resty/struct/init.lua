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
    for i = 1, format:len() do
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
            local char = (args[i]):sub(1, 1)
            buff:append(data)
        elseif 'b' == case then
            -- signed char
            local char = (args[i]):byte(1)
            local data = s.set_int(char, 1)
            buff:append(data)
        elseif 'B' == case then
            -- unsigned char
            local char = (args[i]):byte(1)
            local data = s.set_uint(char, 1)
            buff:append(data)
        elseif '?' == case then
            -- _Bool
            local flag = args[i] and 1 or 0
            local data = s.set_uint(flag, 1)
            buff:append(data)
        elseif 'h' == case then
            -- short
            local data = s.set_int(args[i], 2, endian)
            buff:append(data)
        elseif 'H' == case then
            -- unsigned short
            local data = s.set_uint(args[i], 2, endian)
            buff:append(data)
        elseif 'i' == case then
            -- int
            local data = s.set_int(args[i], 4, endian)
            buff:append(data)
        elseif 'I' == case then
            -- unsigned int
            local data = s.set_uint(args[i], 4, endian)
            buff:append(data)
        elseif 'l' == case then
            -- long
            local data = s.set_int(args[i], 4, endian)
            buff:append(data)
        elseif 'L' == case then
            -- unsigned long
            local data = s.set_uint(args[i], 4, endian)
            buff:append(data)
        elseif 'q' == case then
            -- long long
            local data = s.set_int(args[i], 8, endian)
            buff:append(data)
        elseif 'Q' == case then
            -- unsigned long long
            local data = s.set_uint(args[i], 8, endian)
            buff:append(data)
        elseif 'f' == case then
            -- float
            local data = s.set_float(args[i], 4, endian)
            buff:append(data)
        elseif 'd' == case then
            -- double
            local data = s.set_float(args[i], 8, endian)
            buff:append(data)
        else
            return nil, ("format '%s' at pos %d not support"):format(case, i)
        end
    end
    return buff:getall()
end

function _M.unpack(format, string)
    local t = {}
    local buff = buffer:new()
    buff:set(string)
    local endian
    for i = 1, format:len() do
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
            t[i] = buff:get(1)
        elseif 'b' == case then
            -- signed char
            local data = buff:get(1)
            t[i] = s.get_int(data)
        elseif 'B' == case then
            -- unsigned char
            local data = buff:get(1)
            t[i] = s.get_uint(data)
        elseif '?' == case then
            -- _Bool
            local data = buff:get(1)
            if 0 == s.get_int(data) then
                t[i] = false
            else
                t[i] = true
            end
        elseif 'h' == case then
            -- short
            local data = buff:get(2)
            t[i] = s.get_int(data, endian)
        elseif 'H' == case then
            -- unsigned short
            local data = buff:get(2)
            t[i] = s.get_uint(data, endian)
        elseif 'i' == case then
            -- int
            local data = buff:get(4)
            t[i] = s.get_int(data, endian)
        elseif 'I' == case then
            -- unsigned int
            local data = buff:get(4)
            t[i] = s.get_uint(data, endian)
        elseif 'l' == case then
            -- long
            local data = buff:get(4)
            t[i] = s.get_int(data, endian)
        elseif 'L' == case then
            -- unsigned long
            local data = buff:get(4)
            t[i] = s.get_uint(data, endian)
        elseif 'q' == case then
            -- long long
            local data = buff:get(8)
            t[i] = s.get_int(data, endian)
        elseif 'Q' == case then
            -- unsigned long long
            local data = buff:get(8)
            t[i] = s.get_uint(data, endian)
        elseif 'f' == case then
            -- float
            local data = buff:get(4)
            t[i] = s.get_float(data, endian)
        elseif 'd' == case then
            -- double
            local data = buff:get(8)
            t[i] = s.get_float(data, endian)
        else
            return nil, ("format '%s' at pos %d not support"):format(case, i)
        end
    end
    return t
end

function _M.calcsize(format)
    local count = 0
    for i = 1, format:len() do
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
