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
    local type, endian
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
        elseif 'x' == case then
            -- pad byte
            local data = s.set_uint(0, 1)
            buff:append(data)
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
    local type, endian

end

function _M.calcsize(format)

end

return _M
