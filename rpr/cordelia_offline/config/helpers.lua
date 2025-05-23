function log(e, indent)
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

return log