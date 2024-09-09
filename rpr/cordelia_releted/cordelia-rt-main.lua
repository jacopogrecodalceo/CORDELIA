-- USER CONFIG AREA 1/2 ------------------------------------------------------

-- Dependency Name
local script = "cordelia-rt-functions.lua" -- 1. The target script path relative to this file. If no folder, then it means preset file is right to the target script.

-------------------------------------------------- END OF USER CONFIG AREA 1/2

-- PARENT SCRIPT CALL --------------------------------------------------------

-- Get Script Path
local script_folder = debug.getinfo(1).source:match("@?(.*[\\|/])")
local script_path = script_folder .. script -- This can be erased if you prefer enter absolute path value above.

-- Run the Script
if reaper.file_exists( script_path ) then
  dofile( script_path )
else
  reaper.MB("Missing parent script.\n" .. script_path, "Error", 0)
  return
end

---------------------------------------------------- END OF PARENT SCRIPT CALL

STATE = true

ITEMs = {}
TURNOFF_INSTRUMENTs = {}

PLAY_POS = 0
PLAY_POS_LAST = 0

-- ============================
--      REALTIME PROCESSING
-- ============================

-- Function to handle playback and processing at play position
function init_at_play()
    if STATE then

		-- Update last play position
        PLAY_POS_LAST = reaper.GetPlayPosition()

		local tracks = get_tracks()
		ITEMs = get_items(tracks)

		table.sort(ITEMs, sort_by_position)

        remove_items_before_play_pos()
        send_to_cordelia('schedule "heart", 0, -1')

        STATE = false  -- Toggle STATE to false to avoid repeated execution
    end
end

-- Function to handle actions upon stopping playback
function init_at_stop()
    if not STATE then
        send_to_cordelia('turnoff2_i "heart", 0, 0')

        -- Turn off all scheduled scores
        if next(TURNOFF_INSTRUMENTs) then
            for _, score in pairs(TURNOFF_INSTRUMENTs) do
                send_to_cordelia('turnoff2_i ' .. score.instrument_num .. ', 0, 0')
                
                local mode = 0  -- Turn off all instruments
                local csound_string = 'turnoff_everything ' .. mode .. ', ' .. score.instrument_name
                send_to_cordelia(csound_string)
            end
        end

        -- Reset the state and clear note and score tables
		ITEMs = {}
        TURNOFF_INSTRUMENTs = {}
        STATE = true  -- Toggle STATE back to true for the next cycle
    end
end

function update_play_pos()
	PLAY_POS = reaper.GetPlayPosition() - EPSILON
	PLAY_POS = math.max(0, PLAY_POS)  -- Ensures play_pos is never below 0
	PLAY_POS_LAST = PLAY_POS
end

-- ============================
--     CORDIALIA REAL-TIME
-- ============================

-- Handle real-time communication with Cordelia during playback
local function cordelia_realtime()
    local play_state = reaper.GetPlayState()

    if play_state == 1 then  -- Playback is active

		update_play_pos()
		init_at_play()
        safety_play()

		local index = 1
		while index <= #ITEMs do
			local item = ITEMs[index]
			if item.start_pos <= PLAY_POS then
				if item.type == 'MIDI' then
					--[[ for _, event in pairs(item.events) do
						if event then
							send_to_cordelia(event)
						end
					end ]]
					local group_num = 5
					for i = 1, #item.events, group_num do
						local group = {}
						for j = 0, group_num-1 do
							local event = item.events[i + j]
							if event then
								table.insert(group, event)
							end
						end
						send_to_cordelia(table.concat(group, '\n'))
					end
				elseif item.type == 'TEXT' then
					item.instrument_num = tostring(item.index + 300)

					if item.instrument_name == '@cordelia' then
						local string = 'REAPER_INSTR_START ' .. item.instrument_num .. '\n' .. item.text .. '\nREAPER_INSTR_END'
						send_to_cordelia(string)
					else
						local string = insert_after_pattern(item.text, "%.%w+%(", 'num=' .. item.instrument_num .. ', ' .. item.instrument_name .. ', ')
						send_to_cordelia(string)
					end

					table.insert(TURNOFF_INSTRUMENTs, item)
				end
				table.remove(ITEMs, index)
			else
				index = index + 1
			end
		end

        -- Turn off finished scores
        index = 1
        while index <= #TURNOFF_INSTRUMENTs do
            local item = TURNOFF_INSTRUMENTs[index]
            if item.end_pos <= PLAY_POS then
                local csound_string = 'turnoff2_i ' .. item.instrument_num .. ', 0, 0'
                send_to_cordelia(csound_string)
                table.remove(TURNOFF_INSTRUMENTs, index)
            else
                index = index + 1
            end
        end

    elseif play_state == 0 then  -- Playback is stopped
        init_at_stop()
        send_notes_if_selected()  -- Trigger notes if selected
    end
end

-- ============================
--        INITIALIZATION
-- ============================

-- Function to initialize the script
function init()
    reaper.SetToggleCommandState(SECTION_ID, CMD_ID, 1)  -- Set toggle state to ON
    reaper.RefreshToolbar2(SECTION_ID, CMD_ID)  -- Refresh toolbar button
end

-- Function to handle script cleanup
function cleanup()
    reaper.SetToggleCommandState(SECTION_ID, CMD_ID, 0)  -- Set toggle state to OFF
    reaper.RefreshToolbar2(SECTION_ID, CMD_ID)  -- Refresh toolbar button
end

-- ============================
--            MAIN
-- ============================

-- Main loop that runs the real-time processing
function main()
    cordelia_realtime()
    reaper.defer(main)  -- Schedule the next execution of 'main'
end