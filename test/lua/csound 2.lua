local CORDELIA_CORE = '/Users/j/Documents/PROJECTs/CORDELIA/_core'
local cmd = 'cd "' .. CORDELIA_CORE .. '/_server/" && python3 cordelia.py 2>&1'

local handle = io.popen(cmd)

while true do
    local line = handle:read("*line")
    if not line then break end
    -- process the line as desired
    print(line)
end