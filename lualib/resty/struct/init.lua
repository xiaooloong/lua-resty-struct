local struct = require 'resty.struct.type'

local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function (narr, nrec) return {} end
end

local _M = new_tab(0, 4)

_M._VERSION = '0.0.1'

function _M.pack(format, ...)

end

function _M.unpack(format, string)

end

function _M.calcsize(format)

end

return _M
