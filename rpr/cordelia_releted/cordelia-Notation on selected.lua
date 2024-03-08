local function log(e, indent)
	if type(e) == 'table' then
		indent = indent or 0
		for k, v in pairs(e) do
			local formatting = string.rep(' ', indent) .. k .. ": "
			if type(v) == 'table' then
				reaper.ShowConsoleMsg(formatting .. '\n')
				log(v, indent + 4)
			else
				reaper.ShowConsoleMsg(formatting .. tostring(v) .. '\n')
			end
		end
	else
		reaper.ShowConsoleMsg(tostring(e) .. '\n')
	end
end

-- =================================================================
-- =================================================================
-- =================================================================

local function extract_csv(string)
	local elements = {}
	local paren_count = 0
	local start = 0
	for i = 1, #string do
		local c = string:sub(i, i)
		if c == '(' then
			paren_count = paren_count + 1
		elseif c == ')' then
			paren_count = paren_count - 1
		elseif c == ',' and paren_count == 0 then
			table.insert(elements, string:sub(start + 1, i - 1))
			start = i
		end
	end
	table.insert(elements, string:sub(start + 1))
	local result = {}
	for i, elem in ipairs(elements) do
		elem = elem:match("^%s*(.-)%s*$") -- trim whitespace
		if #elem > 0 then
			table.insert(result, elem)
		end
	end
	return result
end

-- =================================================================
-- =================================================================
-- =================================================================


local function get_item_info(item_id)
	local item = {
		id = item_id,
		take = reaper.GetMediaItemTake(item_id, 0),
		start_pos = reaper.GetMediaItemInfo_Value(item_id, 'D_POSITION'),
		dur = reaper.GetMediaItemInfo_Value(item_id, 'D_LENGTH'),
		is_muted = reaper.GetMediaItemInfo_Value(item_id, 'B_MUTE') == 1
	}

	item.end_pos = item.start_pos + item.dur

	return item
end

local function get_track_name_info(track_name)

	local info = {
		dur = nil,
		dyn = nil,
		env = 'classic',
		freq = nil
	}
	if track_name then
		for _, word in pairs(extract_csv(track_name)) do
			if word:find("^dur") then
				local val = word:match("dur%s*(.-)$")
				info.dur = val
			elseif word:find("^dyn") then
				local val = word:match("dyn%s*(.-)$")
				info.dyn = val
			elseif word:find("^env%.") then
				local val = word:match("env%.(%S+)$")
				info.env = val
			elseif word:find("^freq") then
				local val = word:match("freq%s*(.-)$")
				info.freq = val
			end
		end
	end

	return info
end

local function get_freqs_by_tuning(track)
	local freqs_by_tuning = {}
	for i = 0, 127 do
		local freq = reaper.GetTrackMIDINoteNameEx(0, track, i, 0)
		freq = string.match(freq, 'c%s+(.*)')
		if not freq then
			log('You need to commit the tuning system')
			return
		end
		freqs_by_tuning[i] = freq
	end
	return freqs_by_tuning
end

-- =================================================================
-- =================================================================
-- =================================================================


local function apply_dynamic_change(value, lua_string)
	if lua_string then
		local expr = load("return " .. value .. lua_string)
		if type(expr) == "local function" then
			return expr()
		end
	end
	return value
end

local function get_notes_from_item(info, item)

	local notes = {}
	local _, notes_count, _, _ = reaper.MIDI_CountEvts(item.take)
	for index_note = 0, notes_count - 1 do
		local _, _, is_muted, start_ppqpos, end_ppqpos, chan, pitch, vel, _ = reaper.MIDI_GetNote(item.take, index_note)

		if not is_muted then
			local onset = reaper.MIDI_GetProjTimeFromPPQPos(item.take, start_ppqpos)
			-- onset = onset < 0 and 0 or onset

			if onset <= item.end_pos and onset >= item.start_pos then

				local end_note = reaper.MIDI_GetProjTimeFromPPQPos(item.take, end_ppqpos)

				local dur = apply_dynamic_change(end_note - onset, info.dur)

				if dur > 0 then
					local dyn = apply_dynamic_change(vel / MIDI_CORRECTION, info.dyn)
					local env = info.env
					local freq = apply_dynamic_change(info.freqs_by_tuning[pitch], info.freq)

					table.insert(notes, {
						onset = onset,
						end_note = end_note,
						dur = dur,
						dyn = dyn,
						env = env,
						freq = freq
					})
				end
			end
		end
	end
	return notes
end


local function get_project_info()

	local project_path = reaper.GetProjectPath() .. '/'
	local project_name, extension = reaper.GetProjectName(0):match("(.+)%.(.*)")
	local retval, project_title = reaper.GetSetProjectInfo_String(0, 'PROJECT_TITLE', '', false)

	return project_path, project_name, project_title
end

-- =================================================================
-- =================================================================
-- =================================================================

local function get_selected_items()
	-- Get the number of selected items
	local num_selected_items = reaper.CountSelectedMediaItems(0)

	local selected_items = {}
	-- Iterate over selected items
	for i = 0, num_selected_items - 1 do
		-- Get the selected item at index i
		table.insert(selected_items, reaper.GetSelectedMediaItem(0, i))
	end
	return selected_items
end

NOTEs = {}
local function fill_notes()

	local project_path, project_name, project_title = get_project_info()
	local selected_items = get_selected_items()

	for index, item_id in pairs(selected_items) do
		local item = get_item_info(item_id)
		local track = get_track_info(reaper.GetMediaItemTrack(item.id))
		local take = reaper.GetActiveTake(item.id)
		if take ~= nil and reaper.TakeIsMIDI(item.id) then
			local _, track_name = reaper.GetTrackName(track)
			local info = get_track_name_info(track_name)
			info.freqs_by_tuning = get_freqs_by_tuning(track)
			local item_notes = get_notes_from_item(info, item.id)

			for _, note in pairs(item_notes) do
				table.insert(NOTEs, note)
			end
		end
	end
end

local CLEFs = {
    ['treble^8'] = {94, 127},
    ['treble'] = {72, 94},
    ['bass'] = {52, 72},
    ['bass_8'] = {38, 52},
    ['bass_15'] = {0, 38}
}

local function get_clef_suggestion(note_num)
    for clef_name, limits in pairs(CLEFs) do
        local lower_limit = limits[1]
        local upper_limit = limits[2]
        if lower_limit <= note_num and note_num < upper_limit then
            return clef_name
        end
    end
end


fill_notes()



-- Set of a list of name
-- Dict sorted as onseting point
local lilypond_main = {}
local new_staffs = {}
local break_num = {0}

local staffs = {string.format('\\new StaffGroup <<')}
for clef_name, clef_limits in pairs(CLEFs) do
	table.insert(staffs, string.format('\\new Staff = "%s_%s" { \\clef "%s" }', clef_name, clef_name))
end
table.insert(staffs, '>>')

new_staffs[#new_staffs + 1] = table.concat(staffs, '\n')
--octave = put_octave(clef, instruments[instrument_name][0]['note_num'])

for _, note in pairs(NOTEs) do
	--print(p['note_num'], p['note_name'], p['freq'], p['cents_diff'])

	-- \context Staff = "org" \new Voice { s4*##e0.333 f,, 4*##e1.324 _"+1.96¢" }
	local note_name = p['note_name']
	local note_num = p['note_num']
	local dur = p['dur']
	local dyn = string.format('\\set fontSize = %d', math.floor(scale_between_ranges(p["dyn"], -11, 0)))
	local cents_diff = p['cents_diff']

	local local_clef = get_clef_suggestion(note_num)
	--local_octave = put_octave(local_clef if local_clef else clef, note_num)
	--note_name = abjad.NamedPitch(note_name).transpose(n=abjad.NamedInterval(abjad.NumberedInterval(local_octave*36))).get_name()
	local string = {
		string.format('\\context Staff = "%s_%s" \\new Voice ', instrument_name_no, local_clef),
		'\t',
		'{',
		string.format('\\clef "%s"', local_clef),
		dyn,
		string.format('s4*##e%.3f', note.onset),
		note_name,
		string.format('4*##e%.3f', note.dur),
		string.format('_"%s"', cents_diff .. '¢'),
		'}'
	}

	if local_clef and local_clef ~= clef then
		clef = local_clef
	end

	table.insert(lilypond_main, table.concat(string, ' '))
	local i_onset = math.floor(onset) - (math.floor(onset) % MEASURE_PER_SYSTEM)

	if not break_num[i_onset] then
		print(i_onset)
		table.insert(lilypond_main, string.format('\\context Staff = "timeline" \\new Voice \t{ s4*##e%d \\break }', i_onset))
		break_num[i_onset] = true
	end
end

table.insert(lilypond_main, string.format('\\context Staff = "timeline" \\new Voice \t{ s4*##e%d \\break }', break_num[#break_num] + 5))

print(string.format('---There are %d notes', #lilypond_main))
table.insert(lilypond_main, 1, '<<')

local lilypond_header = [[
	%===================================
	\new RhythmicStaff = "timeline" \with {
	\consists #bar-number-engraver
	\override BarLine.stencil =
	#(grob-transformer
		'stencil
		(lambda (grob orig)
		(let ((text (ly:text-interface::print grob)))
			(ly:stencil-add
			orig
			(ly:stencil-translate
			(ly:stencil-aligned-to text X RIGHT) '(-0.6 . 0.6))))))
	\override BarLine.font-size = #-8
	\override BarLine.font-series = #'bold
	} $(empty-music)
	\time 1/4
	%===================================
]]

table.insert(lilypond_main, 2, lilypond_header)

lilypond_main = table.concat(lilypond_main, '\n')

local lilypond_architecture = {
	lilypond_header,
	lilypond_version,
	lilypond_local functions,
	lilypond_paper,
	lilypond_layout,
	lilypond_main
}

local f = io.open(output, 'w')
f:write(table.concat(lilypond_architecture, '\n'))
f:close()

os.execute('lilypond -djob-count=10 ' .. output)

local end_time = os.time()
-- Calculate the elapsed time
local elapsed_time = end_time - start_time

-- Print the elapsed time in seconds
print(string.format('---Elapsed time: %d seconds', elapsed_time))


local local function get_selected_items()
	-- Get the number of selected items
	local num_selected_items = reaper.CountSelectedMediaItems(0)

	local selected_items = {}
	-- Iterate over selected items
	for i = 0, num_selected_items - 1 do
		-- Get the selected item at index i
		table.insert(selected_items, reaper.GetSelectedMediaItem(0, i))
	end
	return selected_items
end

local local function get_midi_info_from_item(item)
	local take = reaper.GetMediaItemTake(item, 0)
	if reaper.TakeIsMIDI(take) then
		
	end

end

local local function main()
	local selected_items = get_selected_items()

	for _, item in ipairs(selected_items) do
		local filename, onset, duration = get_info_item(item)
		local cmd = SCRIPT_PATH .. ' "' .. filename .. '"'
		--cmd = cmd .. ' -e -g -t'
		cmd = cmd .. ' -s ' .. onset
		cmd = cmd .. ' -d ' .. duration
		cmd = cmd .. ' -o "' .. directory .. '"'

		if color ~= 'None' then
			cmd = cmd .. ' -c "' .. color .. '"'
		end

		if flags then
			cmd = cmd .. ' ' .. flags
		end
		
		--reaper.ShowConsoleMsg(cmd)
		_ = reaper.ExecProcess(cmd, -2)

	end
end

main()