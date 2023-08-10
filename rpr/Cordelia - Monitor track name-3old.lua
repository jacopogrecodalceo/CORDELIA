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

console = true -- Display debug messages in the console
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
is_cordelia_instr = false

--------------------------------------------------------------------------------
-- PATH --
--------------------------------------------------------------------------------

instr_json_path = '/Users/j/Documents/PROJECTs/CORDELIA/_setting/instr.json'

--------------------------------------------------------------------------------
-- DEPENDENCIES --
--------------------------------------------------------------------------------

dofile( reaper.GetResourcePath() ..
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
function set_button_state( set )
    local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
    reaper.SetToggleCommandState( sec, cmd, set or 0 )
    reaper.RefreshToolbar2( sec, cmd )
end

function exit()
    set_button_state()
end

--------------------------------------------------------------------------------
-- OTHER --
--------------------------------------------------------------------------------

function create_imgui_context()
    ctx = reaper.ImGui_CreateContext(context_label)
    reaper.ImGui_WindowFlags_AlwaysAutoResize()
end


function showImGUI()
    if not reaper.ImGui_ValidatePtr(ctx, 'ImGui_Context*') then
        ctx = reaper.ImGui_CreateContext('Cordelia instr GUI')
        reaper.ImGui_WindowFlags_AlwaysAutoResize()
    end

	local visible, open = reaper.ImGui_Begin(ctx, 'Cordelia instr', true, window_flags)
    --reaper.ImGui_SetNextWindowPos(ctx, pos_x, pos_y, true, pivot_x = 0.0, pivot_y = 0.0)
	if visible then

        for type, i_tab_names in pairs(instrs) do
            reaper.ImGui_SeparatorText(ctx, type)
            for i, name in ipairs(i_tab_names) do
                if reaper.ImGui_Selectable(ctx, name) then
                    return name
                end
            end
        end

		reaper.ImGui_End(ctx)
	end

    local is_hovered = reaper.ImGui_IsWindowHovered(ctx, reaper.ImGui_HoveredFlags_AnyWindow())
    if is_hovered then
        reaper.defer(showImGUI)
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
                    local selected_name = showImGUI()
                    if selected_name then
                        log(selected_name)
                        reaper.GetSetMediaTrackInfo_String(track, "P_NAME", '@' .. selected_name, true)
                    end
                end
                -- Perform your actions when the mouse is over the track name
            end
        end
    end
    reaper.defer(updateGUI)
end

--------------------------------------------------------------------------------
-- MAIN --
--------------------------------------------------------------------------------

function main()

end

function run()

    reaper.ImGui_SetNextWindowBgAlpha( ctx, 1 )

    if not reaper.ImGui_ValidatePtr( ctx, 'ImGui_Context*' ) then
        create_imgui_context()
    end
    local imgui_visible, imgui_open = reaper.ImGui_Begin(ctx, context_label, true, reaper.ImGui_WindowFlags_NoCollapse())

    if imgui_visible then

        imgui_width, imgui_height = reaper.ImGui_GetWindowSize( ctx )

        main()
        
        --------------------

        reaper.ImGui_End(ctx)
    end

    if imgui_open and not reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_Escape()) and not process then
        reaper.defer(run)
    end

end

--------------------------------------------------------------------------------
-- INIT --
--------------------------------------------------------------------------------

function init()
    set_button_state( 1 )
    reaper.atexit( exit )
  
    create_imgui_context()
  
    reaper.defer(run)
end
  
if not preset_file_init then
    init()
end