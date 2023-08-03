is_file, text_file = reaper.GetUserFileNameForRead("", "Select a file", "")


function create_line_item(track, pos, len, text)

	local item = reaper.CreateNewMIDIItemInProj(track, pos, pos+len)
	local take = reaper.GetTake(item, 0)

	--reaper.SetMediaItemInfo_Value(item, "D_POSITION", pos)
	--reaper.SetMediaItemInfo_Value(item, "D_LENGTH", len)

	if text ~= nil then
		reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", text, 1)
	end
	
	return item
  
end

function main()

	-- Begining of the undo block. Leave it at the top of your main function.
    
	selected_tracks_count = reaper.CountSelectedTracks(0)
  
	if selected_tracks_count > 0 then
  
		selected_track = reaper.GetSelectedTrack(0, 0)

		local lines = {}
		for line in io.lines(text_file) do 

			create_line_item(selected_track, 5*#lines, 5, line)
			lines[#lines + 1] = line

		end


	end
end
  

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

main()

reaper.UpdateArrange()
reaper.Undo_EndBlock('Insert new MIDI item on selected tracks', -1)
reaper.PreventUIRefresh(-1)