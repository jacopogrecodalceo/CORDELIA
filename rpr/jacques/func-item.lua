item = {}

local script_path = debug.getinfo(1,'S').source:sub(2):match("(.*/)")
local path = dofile(script_path .. 'func-path.lua')

function item.get_info(item_)
    local take = reaper.GetActiveTake(item_)
    if not take or reaper.TakeIsMIDI(take) then return nil end-- ignore MIDI
    -- -------------------------------------------------------------------------- --
    --                                    ITEM                                    --
    -- -------------------------------------------------------------------------- --
    local onset = reaper.GetMediaItemInfo_Value(item_, "D_POSITION")
    local duration = reaper.GetMediaItemInfo_Value(item_, "D_LENGTH")
    local fadein = reaper.GetMediaItemInfo_Value(item_, "D_FADEINLEN")
    local fadeout = reaper.GetMediaItemInfo_Value(item_, "D_FADEOUTLEN")

    -- -------------------------------------------------------------------------- --
    --                                   SOURCE                                   --
    -- -------------------------------------------------------------------------- --
    local source = reaper.GetMediaItemTake_Source(take)
	local channels = reaper.GetMediaSourceNumChannels(source)
    local path_ = reaper.GetMediaSourceFileName(source)
    if path_ == "" then
        reaper.ShowMessageBox("Source path not found at " .. onset, "Error", 0)
        reaper.SetEditCurPos(onset, true, true)
        return false, nil
    end
    local offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")

    -- -------------------------------------------------------------------------- --
    --                                    TABLE                                   --
    -- -------------------------------------------------------------------------- --
    local info = {
            onset = onset,
            duration = duration,
            fadein = fadein,
            fadeout = fadeout,
            offset = offset,
            path = path_,
            channels = channels,
            take = take,
        }

    return info
end

function item.create_emtpy(track, onset, duration, loop)
    local item_ = reaper.AddMediaItemToTrack(track)
    reaper.SetMediaItemInfo_Value(item_, "D_POSITION", onset) -- start position
    reaper.SetMediaItemInfo_Value(item_, "D_LENGTH", duration)   -- 1 second length

    if loop then
        reaper.GetMediaItemInfo_Value(item_, "B_LOOPSRC", loop)
    end

    return item_
end

function item.fill(item_, path_, offset, adapt_length)
	-- Add the WAV file to the track
	local take = reaper.AddTakeToMediaItem(item_)
	local source = reaper.PCM_Source_CreateFromFile(path_)
	reaper.SetMediaItemTake_Source(take, source)
    if offset then reaper.SetMediaItemTakeInfo_Value(take, "D_STARTOFFS", offset) end

    local channels = reaper.GetMediaSourceNumChannels(source)
    reaper.SetMediaTrackInfo_Value(reaper.GetMediaItem_Track(item_), "I_NCHAN", channels)

    if adapt_length then
        local source_length = reaper.GetMediaSourceLength(source)
        reaper.SetMediaItemInfo_Value(item_, "D_LENGTH", source_length)
    end

    reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", path.get_file_name(path_), true)

    reaper.PCM_Source_BuildPeaks(source, 0)

end

function item.remove(item, track)
    if not track then
        track = reaper.GetMediaItem_Track(item)
    end
	reaper.DeleteTrackMediaItem(track, item)
end


return item
