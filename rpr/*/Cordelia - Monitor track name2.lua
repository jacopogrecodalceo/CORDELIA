dofile( reaper.GetResourcePath() ..
   "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")

local json = require("dkjson")

function log(string)
	reaper.ShowConsoleMsg(tostring(string) .. '\n')
end

function log_table(table, indent)
    indent = indent or 0
    local indentStr = string.rep(" ", indent)

    for key, value in pairs(table) do
        if type(value) == "table" then
            log(indentStr .. key .. ": {")
            log_table(value, indent + 4)
            log(indentStr .. "}")
        else
            log(indentStr .. key .. ": " .. tostring(value))
        end
    end
end

local CORDELIA_INSTR_JSON = '/Users/j/Documents/PROJECTs/CORDELIA/_setting/instr.json'

function get_cordelia_instr()
    local file = io.open(CORDELIA_INSTR_JSON, 'r')
    if file then
        local content = file:read("*all")
        file:close()
        local instrs = {
            instr = {},
            sonvs = {}
        }

        for instr_name, p in pairs(json.decode(content)) do
            if p.type == 'instr' then
                table.insert(instrs.instr, instr_name)
            elseif p.type == 'sonvs' then
                table.insert(instrs.sonvs, instr_name)
            end
        end

        return instrs

    else
        return nil
    end
end

local window_flags = reaper.ImGui_WindowFlags_NoDecoration()       |
reaper.ImGui_WindowFlags_NoDocking()          |
reaper.ImGui_WindowFlags_AlwaysAutoResize()   |
reaper.ImGui_WindowFlags_NoSavedSettings()    |
reaper.ImGui_WindowFlags_NoNav()

local ctx = reaper.ImGui_CreateContext('Cordelia instr GUI', window_flags)
reaper.ImGui_WindowFlags_AlwaysAutoResize()
function showImGUI()

    if not reaper.ImGui_ValidatePtr(ctx, 'ImGui_Context*') then
        ctx = reaper.ImGui_CreateContext('Cordelia instr GUI')
    end

    if reaper.ImGui_Begin(ctx, "Cordelia's instr", true, window_flags) then
        for _, name in ipairs(instrs.instr) do
            reaper.ImGui_Text(ctx, name)
            reaper.ImGui_Text(ctx, _)
        end
        reaper.ImGui_End(ctx)
    end
    local is_hovered = ImGui.IsItemHovered(ctx) -- Hovered
    if is_hovered then
        reaper.defer(showImGUI
    end

end

function is_mouse_over(track)

    if not track then
        return false
    end

    local retval, coordinates_with_space = reaper.GetSetMediaTrackInfo_String(track, "P_UI_RECT:tcp.label", "", false)

    local coords = {}
    for c in coordinates_with_space:gmatch("%S+") do
        table.insert(coords, tonumber(c))
    end

    if retval then
        local x, y = reaper.GetMousePosition()
--        reaper.ShowConsoleMsg(tostring(x) .. "\n")
--        reaper.ShowConsoleMsg(tostring(y) .. "\n")
        local track_name_x, track_name_y, track_name_width, track_name_height = table.unpack(coords)

        return x >= track_name_x and x <= track_name_x + track_name_width and y <= track_name_y and y >= track_name_y - track_name_height
    end

    return false
end

function updateGUI()

    local track_count = reaper.CountTracks(0)

    if track_count > 0 then
        for i = 1, track_count do
            local track = reaper.GetTrack(0, i - 1)
            if is_mouse_over(track) then
                local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
                local is_cordelia_instr = string.sub(track_name, 1, 1) == "@"
                
                if is_cordelia_instr then
                    showImGUI()
                end
                -- Perform your actions when the mouse is over the track name
            end
        end
    end
    reaper.defer(updateGUI)
end

updateGUI()






