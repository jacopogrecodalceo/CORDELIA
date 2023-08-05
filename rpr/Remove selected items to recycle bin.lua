function move_to_trash(file_path)

    if type(file_path) == "string" and file_path ~= "" then
        local quoted_path = '"' .. file_path .. '"'
        local cmd = 'mv ' .. quoted_path .. ' ~/.Trash'

        -- Check if the file exists before moving it to the trash
        local file_exists = os.execute('test -e ' .. quoted_path)

        if file_exists then
            os.execute(cmd)
            print("File moved to Trash:", file_path)
        else
            print("File not found:", file_path)
        end
    end
end


function get_selected_items()

	local selected_items_count = reaper.CountSelectedMediaItems(0)

	if selected_items_count == 0 then
		reaper.ShowConsoleMsg('No selected media items')
	end

	for i = 0, selected_items_count-1  do

		-- GET ITEMS
		local item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
		local take = reaper.GetActiveTake(item)
		local source = reaper.GetMediaItemTake_Source(take)
		local input_file = reaper.GetMediaSourceFileName(source, "")

		local track = reaper.GetMediaItem_Track(item)

		move_to_trash(input_file)

		reaper.DeleteTrackMediaItem(track, item)
		reaper.DeleteTrack(track)

	end

end


function main()

	reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
	get_selected_items()
	reaper.Undo_EndBlock('Remove selected items to recycle bin', -1) -- End of the undo block. Leave it at the bottom of your main function.

end

--reaper.PreventUIRefresh(1) -- Prevent UI refreshing. Uncomment it only if the script works.
main() -- Execute your main function
--reaper.PreventUIRefresh(-1)  -- Restore UI Refresh. Uncomment it only if the script works.
reaper.UpdateArrange() -- Update the arrangement (often needed)