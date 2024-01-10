--[[
 * ReaScript Name: Cordelia, show instruments name on mouse hover
 * Author: Cordelia
 * Author URI: 
 * Repository: 
 * Licence: GPL v3
 * Version: 1.0
--]]

--[[
 * Changelog
 * v1.0 (2023-02-21)
  + Initial release
--]]

--------------------------------------------------------------------------------
-- USER CONFIG AREA --
--------------------------------------------------------------------------------

window_flags =    reaper.ImGui_WindowFlags_NoDecoration()       |
                    reaper.ImGui_WindowFlags_NoDocking()          |
                    reaper.ImGui_WindowFlags_AlwaysAutoResize()   |
                    reaper.ImGui_WindowFlags_NoSavedSettings()    |
                    reaper.ImGui_WindowFlags_NoNav()

--------------------------------------------------------------------------------
                                                   -- END OF USER CONFIG AREA --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- GLOBALS --
--------------------------------------------------------------------------------

context_label = 'Cordelia instruments'
is_hover_track = false
selected_track = ''
label_x = 0
label_y = 0

--------------------------------------------------------------------------------
-- PATH --
--------------------------------------------------------------------------------

instr_json_path = '/Users/j/Documents/PROJECTs/CORDELIA/_setting/instr.json'

--------------------------------------------------------------------------------
-- DEPENDENCIES --
--------------------------------------------------------------------------------

dofile(reaper.GetResourcePath() ..
   "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")

local json = require("dkjson")

--------------------------------------------------------------------------------
                                                       -- END OF DEPENDENCIES --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- DEBUG --
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- GET JSON --
--------------------------------------------------------------------------------

function get_cordelia_instr()
    local file = io.open(instr_json_path, 'r')
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

        for _, t in pairs(instrs) do
            table.sort(t)
        end

        return instrs

    else
        return nil
    end
end

instrs = get_cordelia_instr()

--------------------------------------------------------------------------------
-- DEFER --
--------------------------------------------------------------------------------

-- Set ToolBar Button State
function set_button_state(set)
    local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
    reaper.SetToggleCommandState(sec, cmd, set or 0)
    reaper.RefreshToolbar2(sec, cmd)
end

function exit()
    set_button_state()
end

--------------------------------------------------------------------------------
-- CHECK HOVER --
--------------------------------------------------------------------------------

function check_if_hover_imgui()
    if reaper.ImGui_ValidatePtr(ctx, 'ImGui_Context*') then
        return reaper.ImGui_IsWindowHovered(ctx, reaper.ImGui_HoveredFlags_AnyWindow())
    else
        return false
    end
end

function check_if_hover_track()
    local track_count = reaper.CountTracks(0)

    if track_count > 0 then
        for i = 1, track_count do
            local track = reaper.GetTrack(0, i - 1)
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
                local is_hover = x >= track_name_x and x <= track_name_x + track_name_width and y <= track_name_y and y >= track_name_y - track_name_height

                if is_hover then
                    local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)

                    label_x = track_name_x + track_name_width/2
                    label_y = track_name_y + track_name_height
                    selected_track = track
                    is_hover_track = string.sub(track_name, 1, 1) == "@"   
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- IMGUI --
--------------------------------------------------------------------------------

function create_imgui_context()
    ctx = reaper.ImGui_CreateContext(context_label)
    reaper.ImGui_WindowFlags_AlwaysAutoResize()
    reaper.ImGui_SetNextWindowPos(ctx, reaper.ImGui_PointConvertNative(ctx, label_x, label_y))
end

function create_popup(track)
    if not reaper.ImGui_ValidatePtr(ctx, 'ImGui_Context*') then
        create_imgui_context()
    end

    local imgui_width, imgui_height = reaper.ImGui_GetWindowSize(ctx)

    local imgui_visible, imgui_open = reaper.ImGui_Begin(ctx, context_label, true, window_flags)

    for type, i_tab_names in pairs(instrs) do
        reaper.ImGui_SeparatorText(ctx, type)
        for i, name in ipairs(i_tab_names) do
            if reaper.ImGui_Selectable(ctx, name) then
                reaper.GetSetMediaTrackInfo_String(track, "P_NAME", '@' .. name, true)
                is_hover_track = false
            end
        end
    end

    if not check_if_hover_imgui() then
        is_hover_track = reaper.ImGui_IsMouseClicked(ctx, reaper.ImGui_MouseButton_Left())
    end

    reaper.ImGui_End(ctx)
end

--------------------------------------------------------------------------------
-- MAIN --
--------------------------------------------------------------------------------

function main()
    if not is_hover_track then
        check_if_hover_track()
    else
        create_popup(selected_track)
    end
    reaper.defer(run)

end

function run()
    main()
end

--------------------------------------------------------------------------------
-- INIT --
--------------------------------------------------------------------------------

function init()
    set_button_state(1)
    reaper.atexit(exit)
  
    create_imgui_context()
  
    reaper.defer(run)
end
  
if not preset_file_init then
    init()
end