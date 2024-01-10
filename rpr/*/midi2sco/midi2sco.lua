
function log(string)
	reaper.ShowConsoleMsg(string .. '\n')
end

function remove_extension(file_path)
	-- Find the last dot (.) in the string
	local last_dot = file_path:match(".*%.(.*)")

	-- If a dot is found, remove the extension
	local name_without_extension = file_path
	if last_dot then
		name_without_extension = file_path:sub(1, -(#last_dot) - 2) -- Subtract 2 to remove the dot and the character before it
		return name_without_extension
	end
end

function main(project_name, file_path)
	-- Get the active MIDI editor
	local midieditor = reaper.MIDIEditor_GetActive()

	-- Check if a MIDI editor is open
	if midieditor ~= nil then
		-- Get the current take in the MIDI editor
		local take = reaper.MIDIEditor_GetTake(midieditor)

		-- Check if the take is valid
		if take ~= nil then
			local file = io.open(file_path, 'w')
			local retval, notecnt, ccevtcnt, textsyxevtcnt = reaper.MIDI_CountEvts(take)

			--INFO
			local format = '%y%m%d at %H.%M.%S' -- YYYY-MM-DD HH:MM:SS
			local time = os.date(format)

			file:write('; DATE: ' .. time .. '\n')
			file:write('; FROM: ' .. project_name .. '\n')

			local retval, track_name = reaper.GetTrackName(reaper.GetMediaItemTake_Track(take), '')
			file:write('; INFO: ', track_name .. '\n')

			file:write(';' .. string.rep('-', 64) .. '\n')

			local default_string = ';\t' .. 'name' .. '\t' .. 'onset' .. '\t' .. 'dur' .. '\t' .. 'dyn' .. '\t' .. 'env' .. '\t' .. 'freq'
			file:write(default_string .. '\n')
			file:write(';' .. string.rep('-', 64) .. '\n')

			for note_index = 0, notecnt - 1 do
				local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, note_index)
				-- Sinstr, gkabstime, kdur, kdyn, kenv, $kcps
				local name = 'i'
				local onset = reaper.MIDI_GetProjTimeFromPPQPos(take, startppqpos)
				local end_pos = reaper.MIDI_GetProjTimeFromPPQPos(take, endppqpos)
				local dur = end_pos - onset
				local dyn = vel / 127
				local env = 'gi' .. (track_name:match('env.%s+(.*),') or 'classic')
				local freq = reaper.GetTrackMIDINoteNameEx(0, reaper.GetMediaItemTake_Track(take), pitch, chan)
				freq = freq:match('c.%s+(.*)')
				
				local string = name .. '\t' .. onset .. '\t' .. dur .. '\t' .. dyn .. '\t' .. env .. '\t' .. freq

				file:write(string .. '\n')
			end
			file:close()
		end
	end
end

local project_name, _ = reaper.GetProjectName(0, '')
local retval, file_path = reaper.JS_Dialog_BrowseForSaveFile('Save as..', '/Users/j/Desktop', remove_extension(project_name) .. '-score.sco', '')

if retval then
	main(project_name, file_path)
end
