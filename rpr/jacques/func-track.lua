track = {}

function track.create_new_under_item(item_, free_mode)
    local track_ = reaper.GetMediaItem_Track(item_)
    local track_index = reaper.GetMediaTrackInfo_Value(track_, "IP_TRACKNUMBER")

    reaper.InsertTrackAtIndex(track_index, true)
    if free_mode then
        --I_FREEMODE : int * : 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing)
        reaper.SetMediaTrackInfo_Value(track_, 'I_FREEMODE', 1)
        reaper.UpdateTimeline()
    end

    return reaper.GetTrack(0, track_index)
end

function track.set_name(track_, name)
    -- Lua: boolean retval, string stringNeedBig = reaper.GetSetMediaTrackInfo_String(MediaTrack tr, string parmname, string stringNeedBig, boolean setNewValue)
    reaper.GetSetMediaTrackInfo_String(track_, "P_NAME", name, true)
end

function track.create_new(name, free_mode)
    local track_count = reaper.CountTracks(0)
    reaper.InsertTrackAtIndex(track_count, true)
    local new_track = reaper.GetTrack(0, track_count)

    if name then
       track.set_name(new_track, name)
    end

    if free_mode then
        reaper.SetMediaTrackInfo_Value(new_track, 'I_FREEMODE', 1)
        reaper.UpdateTimeline()
    end

    return new_track
end
return track