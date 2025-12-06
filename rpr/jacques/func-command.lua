command = {}

function command.exec_in_terminal(command_string, exit)
    exit = exit == nil and true or exit  -- default to true

	local osa_command
	if exit then
		osa_command = "osascript -e 'tell application \"Terminal\" to do script \"" .. command_string .. ";exit\"'"
	else
		osa_command = "osascript -e 'tell application \"Terminal\" to do script \"" .. command_string .. "\"'"
	end
    ---reaper.ShowMessageBox(osa_command, "Error", 0)

	--reaper.ShowMessageBox(osa_command, "Show command", 0)
	os.execute(osa_command)
end



return command
