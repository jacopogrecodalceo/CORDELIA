function look_for_wav(directory)
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('find "'..directory..'" -type f -name "*.wav"')
	for filename in pfile:lines() do
			i = i + 1
			t[i] = filename
	end
	pfile:close()
	return t
end

function dialog()
	local retval, folder = reaper.JS_Dialog_BrowseForFolder("***", "/Users/j/Documents/PROJECTs")
	if retval then
		return folder
	end
end

function add_each_as_a_track(file_list)
	-- Iterate over the list of files
	for i, path in ipairs(file_list) do

			local name = string.match(path, "^.+/(.+)$") -- Extract the file name from the path
			name = string.gsub(name, "%..+$", "") -- Remove the file extension

			 -- Create a new track
			local track_index = reaper.GetNumTracks()
			reaper.InsertTrackAtIndex(track_index, true)

			 -- Set the track name
			local track = reaper.GetTrack(0, track_index)
			local instr_name = name:match('[^%-]+$')
			reaper.GetSetMediaTrackInfo_String(track, "P_NAME", instr_name, true)
			
			-- Add the WAV file to the track
			local item = reaper.AddMediaItemToTrack(track)
			local take = reaper.AddTakeToMediaItem(item)
			local src = reaper.PCM_Source_CreateFromFile(path)


			reaper.SetMediaItemTake_Source(take, src)
			reaper.PCM_Source_BuildPeaks(src, 0)

			reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", instr_name, true)
			reaper.SetMediaItemInfo_Value(item, "D_POSITION", reaper.GetCursorPosition())
			-- Adjust the item length to match the WAV file length
			local source_length = reaper.GetMediaSourceLength(reaper.GetMediaItemTake_Source(take))
			-- Set the track number of channel to the item channels
			local channels = reaper.GetMediaSourceNumChannels(src)
			if channels > 2 then
				reaper.SetMediaTrackInfo_Value(track, "I_NCHAN", channels)
			end

			reaper.SetMediaItemInfo_Value(item, "D_LENGTH", source_length)

	end
end


folder = dialog()
files = look_for_wav(folder)
if #files > 35 then files = {} end

function main()

	reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

	-- LOOP THROUGH SELECTED ITEMS
	
	if #files > 1 then
		add_each_as_a_track(files)
	end
	reaper.Undo_EndBlock("Offset selected media items source positions by snap offset length", -1) -- End of the undo block. Leave it at the bottom of your main function.

end

reaper.PreventUIRefresh(1) -- Prevent UI refreshing. Uncomment it only if the script works.

main() -- Execute your main function

reaper.PreventUIRefresh(-1)  -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)
