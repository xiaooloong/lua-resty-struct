local ffi = require 'ffi'
local ffi_new = ffi.new
local ffi_copy = ffi.copy
local ffi_string = ffi.string
local reverse = string.reverse
local tostring = tostring
local tonumber = tonumber
local machine_endian = ffi.abi('le') and 'le' or 'be'

local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function (narr, nrec) return {} end
end

local _M = new_tab(0, 8)

_M._VERSION = '0.0.1'

function _M.get_int(data, endian)
    local len = #data
    if endian and endian ~= machine_endian then
        data = reverse(data)
    end
    local int = ffi_new(('int%d_t[1]'):format(len * 8))
    ffi_copy(int, data, len)
    if 8 == len then
        return tostring(int[0]):sub(1, -3)
    else
        return tonumber(int[0])
    end
end

function _M.set_int(number, size, endian)
    local int = ffi_new(('int%d_t[1]'):format(size * 8), number)
    local data = ffi_string(int, size)
    if 1 ~= size and endian and endian ~= machine_endian then
        return reverse(data)
    else
        return data
    end
end

function _M.get_uint(data, endian)
    local len = #data
    if endian and endian ~= machine_endian then
        data = reverse(data)
    end
    local uint = ffi_new(('uint%d_t[1]'):format(len * 8))
    ffi_copy(uint, data, len)
    if 8 == len then
        return tostring(uint[0]):sub(1, -4)
    else
        return tonumber(uint[0])
    end
end

function _M.set_uint(number, size, endian)
    local uint = ffi_new(('uint%d_t[1]'):format(size * 8), number)
    local data = ffi_string(uint, size)
    if 1 ~= size and endian and endian ~= machine_endian then
        return reverse(data)
    else
        return data
    end
end

function _M.get_float(data, endian)
    local len = #data
    if endian and endian ~= machine_endian then
        data = reverse(data)
    end
    local float
    if 8 == len then
        float = ffi_new('double[1]')
    else
        float = ffi_new('float[1]')
    end
    ffi_copy(float, data, len)
    return tonumber(float[0])
end

function _M.set_float(number, size, endian)
    local float
    if 8 == size then
        float = ffi_new('double[1]', number)
    else
        float = ffi_new('float[1]', number)
    end
    local data = ffi_string(float, size)
    if endian and endian ~= machine_endian then
        return reverse(data)
    else
        return data
    end
end

return _M