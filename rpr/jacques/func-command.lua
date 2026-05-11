local command = {}

function command.exec_in_terminal(command_string, exit)
    -- Set default value for exit
    exit = exit ~= false

    -- Sanitize command_string (basic example: escape quotes)
    local sanitized_command = command_string:gsub('"', '\\"')

    -- Build the osascript command
	local osa_command = string.format(
		'osascript -e \'tell application "Terminal" to do script "if %s; then exit; else afplay /System/Library/Sounds/Sosumi.aiff; fi"\'',
		sanitized_command
	)

    -- Execute and capture the result
    local success, status, rc = os.execute(osa_command)
    if not success then
			reaper.ShowMessageBox(string.format("Command failed with exit code: %d", rc), "Error", 0)
    end
    return success, status, rc
end

function command.exec_and_capture(command_string)
	-- Write command to temp file, execute, capture output
	local temp_output = os.tmpname()
	local full_command = string.format('%s > "%s" 2>&1', command_string, temp_output)
	
	os.execute(full_command)
	
	-- Read the output file
	local file = io.open(temp_output, 'r')
	if not file then return end
	local output = file:read('*a')
	file:close()
	os.remove(temp_output)
	
	return output
end



return command