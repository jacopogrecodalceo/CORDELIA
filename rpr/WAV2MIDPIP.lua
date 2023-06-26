package.path = reaper.GetResourcePath() .. '/Scripts/sockmonkey72 Scripts/MIDI/?.lua'
local mu = require 'MIDIUtils'
mu.CORRECT_OVERLAPS = true

-- Specify the Python script path
local librosa_script = '/Users/j/Documents/script/librosa_freqs-piptrack.py'
local temp_dir = '/Users/j/Documents/PROJECTs/_temp'

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
		local name, cent_diff, freq = reaper.GetTrackMIDINoteNameEx(0, track, i, 0):match("(%S+)%s+(%S+)%s+(%S+)")
		names[i] = name
		cent_diffs[i] = cent_diff
		freqs[i] = freq
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



function process_file(file_path, take)
	local names, cent_diffs, freqs = get_tuning_list(take)

	if names == nil then
		log('Warning: forgotten names')
	end

	local first_time = nil

	local file = io.open(file_path, 'r')
	if not file then return end

	local midi_buffer = ''

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

end

function get_selected_audio_item(selected)
	local selected_items_count = reaper.CountSelectedMediaItems(0)

	if selected_items_count == 0 then
		log('No item selected')
		return
	end
	
	-- INITIALIZE loop through selected items
	for i = 0, selected_items_count-1  do
		-- GET ITEMS
		local item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
		local take = reaper.GetActiveTake(item)
		local source = reaper.GetMediaItemTake_Source(take)
		-- Check if a media source is available
		if source ~= nil then
			-- Get the file name of the media source
			local file = reaper.GetMediaSourceFileName(source, "")

			local source_start = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")
			local source_end = source_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

			local command = string.format('python3 "%s" "%s" %f %f', librosa_script, file, source_start, source_end)
			os.execute(command)

			local file = string.match(file, "([^/\\]+)%.%w+$")
			--local basename = string.gsub(file, "%..*", "")
			return item
		end
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

function main(file_path)
	reaper.ClearConsole()
	local item = get_selected_audio_item()
	log('Get selected audio')
	local midi_take = create_midi_item(item)
	log('Create midi item: ')
	if midi_take ~= nil then
		local temp_file = temp_dir .. '/' .. 'temp.txt'
		log('Processing.. ' .. temp_file)
		process_file(temp_file, midi_take)
		reaper.DeleteTrackMediaItem(reaper.GetMediaItemTrack(item), item)		
	end
	close_console()
end

main()
