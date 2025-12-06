function load_modules(dir)
    local i = 0
    while true do
        local file_name = reaper.EnumerateFiles(dir, i)
        if not file_name then break end

        local mod_name = file_name:match("^func%-(.+)%.lua$")
        if mod_name then
            local file_path = dir .. file_name
            local ok, mod = pcall(dofile, file_path)
            if ok and type(mod) == "table" then
                -- assign module to global variable with the same name as the file suffix
                _G[mod_name] = mod
            end
        end

        i = i + 1
    end
end

local script_path = debug.getinfo(1,'S').source:sub(2):match("(.*/)")
local script_name = 'EXTRATONE MAKER'
load_modules(script_path)
--math.randomseed(os.time())


local function main()


end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)
main()
reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_name, -1)