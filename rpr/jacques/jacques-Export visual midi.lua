local script_path = debug.getinfo(1,'S').source:match[[^@?(.*[\/])[^\/]-$]]

function GET_ALL_MIDI_NOTEs()
    local staves = {}

    local track_count = reaper.CountTracks(0)
    local parent_track_num = 0
    for t = 0, track_count - 1 do
        local track = reaper.GetTrack(0, t)
        local parent_track = reaper.GetParentTrack(track)
        if parent_track then
            parent_track_num = reaper.GetMediaTrackInfo_Value(parent_track, "IP_TRACKNUMBER", "", false)
        
            local _, parent_track_name = reaper.GetSetMediaTrackInfo_String(parent_track, "P_NAME", "", false)
            local parent_track_name = parent_track_name .. '_' .. tostring(math.floor(parent_track_num))
            local item_count = reaper.CountTrackMediaItems(track)

            for i = 0, item_count - 1 do
                local item = reaper.GetTrackMediaItem(track, i)
                local take = reaper.GetActiveTake(item)
                if take and reaper.TakeIsMIDI(take) then
                    local note_count = select(2, reaper.MIDI_CountEvts(take))
                    for n = 0, note_count - 1 do
                        local ok, sel, muted, start_ppq, end_ppq, chan, pitch, vel = reaper.MIDI_GetNote(take, n)

                        local string = reaper.GetTrackMIDINoteNameEx(0, track, pitch, 0)
                        local degree, data, edo12note, freq = string:match('(.+)|(.+)|(.+)%s+(.+)')

                        if ok then
                            table.insert(staves, {
                                staff_name = parent_track_name,
                                selected = sel,
                                muted = muted,
                                onset = reaper.MIDI_GetProjTimeFromPPQPos(take, start_ppq),
                                dur = reaper.MIDI_GetProjTimeFromPPQPos(take, end_ppq - start_ppq),
                                channel = chan,
                                pitch = pitch,
                                velocity = vel,
                                freq = freq,
                                edo12note = edo12note,
                                data = data,
                                degree = degree
                            })
                        end
                    end
                end
            end
        end
    end

    return staves
end

reaper.Undo_BeginBlock()
local staves = GET_ALL_MIDI_NOTEs()

local json = dofile(script_path .. "/json.lua")
local staves_json = json.encode(staves)

local file_path = reaper.GetProjectPath() .. "/staves.json"
local file = io.open(file_path, "w")
file:write(staves_json)
file:close()

reaper.ShowConsoleMsg("TOTAL_NOTEs = " .. tostring(#staves) .. "\n" .. file_path)
reaper.Undo_EndBlock("collect_all_midi_notes", -1)