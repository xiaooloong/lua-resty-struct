# Resty Struct

OpenResty 网络协议基础库，用于解析和构造二进制数据

用法和 python 的 [struct][1] 库相似

代码开发中，请勿用于项目

例：

```lua
local struct = require 'resty.struct'

local binary, err = struct.pack('HHL', 1, 2, 3)

if not binary then print(err) end

local table, count = struct.unpack('HHL', binary)

if table then
    for i = 1, count do
        print(table[i])
    end
else
    print(count) -- error message instead
end

```

  [1]: https://docs.python.org/2/library/struct.html