-- @description MIDI Note Channel Box (gfx/LICE)
-- @version 0.5
-- @author jac
-- @changelog
--   • Cleaned and reorganized code
--   • Improved error handling
--   • Adaptive drawing + layout
--   • Modularized functions for future improvements

----------------------------------------
-- CONFIGURATION
----------------------------------------

local WINDOW_TITLE = "MIDI Channel Box"
local FONT_NAME    = "Andale Mono"
local FONT_SIZE    = 13.5
local LINE_HEIGHT  = 22
local PADDING_X    = 10
local PADDING_Y    = 8

----------------------------------------
-- HELPERS
----------------------------------------

--- Initialize the graphics window
local function init_gfx(w, h)
    gfx.init(WINDOW_TITLE, w, h, 1, 100, 100)
    gfx.setfont(1, FONT_NAME, FONT_SIZE, 0)
end

--- Safe check for active MIDI take
local function get_active_take()
    local midieditor = reaper.MIDIEditor_GetActive()
    if not midieditor then return nil end

    local take = reaper.MIDIEditor_GetTake(midieditor)
    if not (take and reaper.ValidatePtr(take, "MediaItem_Take*")) then return nil end

    return take
end

--- Format table of strings into a single text block
local function format_lines(lines, label)
    if #lines == 0 then
        return label .. ": No note"
    end
    return label .. ":\t" .. table.concat(lines, ", ")
end

----------------------------------------
-- DATA FUNCTIONS
----------------------------------------

--- Get all note channels in the active take
local function get_all_note_channels()
    local take = get_active_take()
    if not take then return "No active take" end

    local _, note_count, _, _ = reaper.MIDI_CountEvts(take)
    local channels = {}

    for i = 0, note_count - 1 do
        local _, _, _, _, _, chan, _, _ = reaper.MIDI_GetNote(take, i)
        channels[#channels+1] = tostring(chan)
    end

    return format_lines(channels, "Sequence")
end

--- Get note channels under the mouse cursor in MIDI editor
local function get_note_channels_under_cursor()
    if reaper.BR_GetMouseCursorContext() ~= "midi_editor" then
        return "-- Outside MIDI editor --"
    end

    local take = get_active_take()
    if not take then return "No active take" end

    local mouse_time = reaper.BR_GetMouseCursorContext_Position()
    local mouse_ppq  = reaper.MIDI_GetPPQPosFromProjTime(take, mouse_time)

    local _, note_count, _, _ = reaper.MIDI_CountEvts(take)
    local events, notes_selected = {}, {}

    for i = 0, note_count - 1 do
        local _, selected, _, startppq, endppq, chan, pitch, _ =
            reaper.MIDI_GetNote(take, i)

        notes_selected[#notes_selected+1] = selected

        if mouse_ppq >= startppq - 0.5 and mouse_ppq <= endppq + 0.5 then
            events[pitch] = { selected = selected, ch = chan }
        end
    end

    local keys = {}
    for pitch in pairs(events) do keys[#keys+1] = pitch end
    table.sort(keys)

    local at_least_one_selected = false
    for _, sel in ipairs(notes_selected) do
        if sel then at_least_one_selected = true break end
    end

    local result = {}
    for _, pitch in ipairs(keys) do
        local ev = events[pitch]
        if at_least_one_selected then
            if ev.selected then
                result[#result+1] = string.format("%d: %d*", pitch, ev.ch)
            end
        else
            result[#result+1] = string.format("%d: %d", pitch, ev.ch)
        end
    end

    return (#result > 0) and table.concat(result, "\t") or "No note under cursor"
end

----------------------------------------
-- DRAWING
----------------------------------------

local last_height = 0

local function draw_text_block(txt)
    -- resize if text grows
    local line_count = select(2, txt:gsub("\n", "\n")) + 1
    local new_height = line_count * LINE_HEIGHT + 2 * PADDING_Y

    if new_height ~= last_height then
        last_height = new_height
        gfx.init(WINDOW_TITLE, gfx.w, new_height, 0, 100, 100)
    end

    -- background
    gfx.set(0.2, 0.2, 0.2, 1)
    gfx.rect(0, 0, gfx.w, gfx.h, 1)

    -- text
    gfx.set(1, .35, .85, 1)
    gfx.x, gfx.y = PADDING_X, PADDING_Y
    gfx.drawstr(txt)
end

----------------------------------------
-- MAIN LOOP
----------------------------------------

local function main_loop()

    local cursor_context = reaper.BR_GetMouseCursorContext()

    local txt = get_note_channels_under_cursor() .. "\n" .. get_all_note_channels()
    draw_text_block(txt)

    if gfx.getchar() >= 0 then
        reaper.defer(main_loop)
    end
end

----------------------------------------
-- INIT
----------------------------------------

init_gfx(260, 60)
main_loop()