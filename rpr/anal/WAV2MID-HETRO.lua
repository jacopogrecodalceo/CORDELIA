package.path = reaper.GetResourcePath() .. '/Scripts/sockmonkey72 Scripts/MIDI/?.lua'
local mu = require 'MIDIUtils'
mu.CORRECT_OVERLAPS = true

-- Specify the Python script path
local SCRIPT = '/Users/j/Documents/script/librosa_freqs-hetro.py'
local temp_dir = '/Users/j/Documents/temp'

function log(string)
	reaper.ShowConsoleMsg(string .. '\n')
end

function close_console()
	local title = reaper.JS_Localize('ReaScript console output', 'common')
	local hwnd = reaper.JS_Window_Find(title, true)
	if hwnd then reaper.JS_Window_Destroy(hwnd) end  
  end

  function get_tuning_list(take)
	local track = reaper.GetMediaItemTake_Track(take)
	local names, cent_diffs, freqs = {}, {}, {}

	for i = 0, 127 do
		local note_name = reaper.GetTrackMIDINoteNameEx(0, track, i, 0)
		if not note_name then return nil end
		names[i] = string.match(note_name, '|([^%d]+%d+)')
		cent_diffs[i] = string.match(note_name, '([%+%-]%d+%.%d+c)')
		freqs[i] = string.match(note_name, '([%d%.]+)$')
	end

	return names, cent_diffs, freqs
end

function find_index_of_nearest(array, value)
	local min_index = 0
	local min_diff = math.huge

	for i, v in ipairs(array) do
		local diff = math.abs(v - value)
		if diff < min_diff then
			min_diff = diff
			min_index = i
		end
	end

	return array[min_index], min_index
end

function insert_midi_note(take, time, duration, midi_note_num, velocity)
	local ppq_start = reaper.MIDI_GetPPQPosFromProjTime(take, time)
	local ppq_end = reaper.MIDI_GetPPQPosFromProjTime(take, time + duration)

	mu.MIDI_InsertNote(take, true, false, ppq_start, ppq_end, 0, midi_note_num, velocity)

	--reaper.MIDI_InsertNote(take, true, false, ppq_start, ppq_end, 0, midi_note_num, velocity, true)
end

function wait_for_file(file_path)
    -- Check for file existence periodically
    local file
    repeat
        file = io.open(file_path, "r")
		local index = 0
        if not file then
            print("Waiting for file:", file_path)
            os.execute("sleep .125")  -- Wait for 1 second before checking again
			index = index + 1
        end
		if index > 8 then
			return
		end
    until file  -- Loop until the file is opened successfully
    if file then
        file:close()  -- Close the file handle
        print("File found:", file_path)
    end
end


function process_file(file_path, take)
	local names, cent_diffs, freqs = get_tuning_list(take)

	if not names then
		log('Warning: forgotten names')
		return false
	end

	local first_time = nil

	wait_for_file(file_path)
	local file = io.open(file_path, 'r')

	mu.MIDI_OpenWriteTransaction(take)

	for line in file:lines() do
		
		local values = {}
		for value in line:gmatch('([^,]+)') do
			value = string.gsub(value, "^%s*(.-)%s*$", "%1") -- Remove leading and trailing spaces
			table.insert(values, value)
		end

		local name, time, dur, dyn, env, freq = table.unpack(values)

		if first_time == nil then
			first_time = tonumber(time)
		end

		local nearest_value, midi_note_num = find_index_of_nearest(freqs, tonumber(freq))

		local velocity = math.floor(tonumber(dyn) * 127)

--[[ 		-- Create the MIDI buffer string for the note event
		local note_on_event = string.pack("BBB", 0x90, midi_note_num, velocity)
		local note_off_event = string.pack("BBB", 0x80, midi_note_num, 0)
		
		-- Calculate the MIDI offset in the buffer
		local offset = math.floor((reaper.MIDI_GetPPQPosFromProjTime(take, tonumber(time))))
		local dur_ppq = math.floor((reaper.MIDI_GetPPQPosFromProjTime(take, tonumber(dur))))
		
		-- Build the MIDI events for note-on and note-off
		local note_on = string.pack("IBs4", offset, 0, note_on_event)
		local note_off = string.pack("IBs4", offset + dur_ppq, 0, note_off_event)
		
		-- Append the events to the buffer
		midi_buffer = midi_buffer .. note_on .. note_off ]]

		insert_midi_note(take, tonumber(time), tonumber(dur), midi_note_num, velocity)
	end

	mu.MIDI_CommitWriteTransaction(take)

	file:close()
	return true

end

function get_selected_audio_item()
	local selected_items_count = reaper.CountSelectedMediaItems(0)

	if selected_items_count == 0 then
		log('No item selected')
		return
	end

	for i = 0, selected_items_count-1  do
		-- GET ITEMS
		local item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
		reaper.SetMediaItemInfo_Value(item, "B_MUTE", 1)
	end

	reaper.PreventUIRefresh(1)
	local first_item_onset = reaper.GetMediaItemInfo_Value(reaper.GetSelectedMediaItem(0, 0), "D_POSITION")

	-- Duplicate items
	reaper.Main_OnCommand(41295, 0)

	-- Glue items
	reaper.Main_OnCommand(40362, 0)

	local glued_item = reaper.GetSelectedMediaItem(0, 0)
	reaper.SetMediaItemInfo_Value(glued_item, "D_POSITION", first_item_onset)
	local take = reaper.GetActiveTake(glued_item)

	-- Get glued item source
	local source = reaper.GetMediaItemTake_Source(take)
--[[ 	-- Remove item
	local track = reaper.GetMediaItem_Track(glued_item)
	reaper.DeleteTrackMediaItem(track, glued_item) ]]
	reaper.PreventUIRefresh(-1)

	-- Check if a media source is available
	if source ~= nil then
		-- Get the file name of the media source
		local file = reaper.GetMediaSourceFileName(source, "")

--[[ 		local source_start = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")
		local source_end = source_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
		local command = string.format('python3 "%s" "%s" %f %f', SCRIPT, file, source_start, source_end) ]]

		local command = string.format('/opt/homebrew/bin/python3.11 "%s" "%s"', SCRIPT, file)
		log(command)
		os.execute(command)

		--local file = string.match(file, "([^/\\]+)%.%w+$")
		--local basename = string.gsub(file, "%..*", "")
		return glued_item
	end
end

function create_midi_item(item)

	local start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
	local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

	-- Create a new MIDI item with the same length
	local midi_item = reaper.CreateNewMIDIItemInProj(reaper.GetMediaItem_Track(item), start, start+length)

	if midi_item ~= nil then
		-- Get the take from the new MIDI item
		local take = reaper.GetActiveTake(midi_item)
		return take
	end

end

function main()
	reaper.ClearConsole()
	local item = get_selected_audio_item()
	log('Get selected audio')
	local midi_take = create_midi_item(item)
	log('Create midi item: ')
	if midi_take ~= nil then
		local temp_file = temp_dir .. '/' .. 'temp.txt'
		log('Processing.. ' .. temp_file)
		local result = process_file(temp_file, midi_take)
		if result then
			os.remove(reaper.GetMediaSourceFileName(reaper.GetMediaItemTake_Source(reaper.GetActiveTake(item)), ""))
			reaper.DeleteTrackMediaItem(reaper.GetMediaItemTrack(item), item)
			close_console()
		end
	end
end

main()
