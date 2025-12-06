local read = {}

dofile( reaper.GetResourcePath() ..
   "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")

-- parse JSONL file into Lua table
function read.jsonl(file_path)
    local json = require('dkjson')
    local objects = {}
    local f = io.open(file_path, "r")
    if not f then return {} end

    for line in f:lines() do
    if line:match("%S") then  -- skip empty lines
        local obj, pos, err = json.decode(line)
        if obj then
            table.insert(objects, obj)
        else
            reaper.ShowConsoleMsg("Failed to parse line: " .. (err or "") .. "\n")
        end
    end
    end

    f:close()
    return objects
end

return read