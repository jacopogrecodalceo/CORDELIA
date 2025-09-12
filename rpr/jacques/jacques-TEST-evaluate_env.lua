-- get the envelope value of a track's envelope by name at cursor position
function get_envelope_value(track, time, target_name)
    if not track then return nil end
    
    local env_count = reaper.CountTrackEnvelopes(track)
    if env_count == 0 then return nil end


    for i = 0, env_count-1 do
        local env = reaper.GetTrackEnvelope(track, i)
        local retval, env_name = reaper.GetEnvelopeName(env, "")
        if retval and env_name == target_name then
            local ok, value = reaper.Envelope_Evaluate(env, time, 0, 0)
            if ok then return value end
        end
    end
    
    return nil -- not found
end

-- EXAMPLE USAGE
local track = reaper.GetSelectedTrack(0,0)
local target_name = 
local cursor_time = reaper.GetCursorPosition()

local value = get_envelope_value(track, cursor_time, "env.a(x) / Cordelia's dummy plugin")
if value then
    reaper.ShowConsoleMsg(
        string.format("Envelope: %s\nValue at cursor: %f\n", target_name, value)
    )
else
    reaper.ShowConsoleMsg("Envelope not found or no value.\n")
end