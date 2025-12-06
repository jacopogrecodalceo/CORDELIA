path = {}

function path.get_project_info()
	local project_name = reaper.GetProjectName(0)
	project_name = project_name:gsub("%.RPP$", "")
	local project_dir = reaper.GetProjectPath()

	if not project_name or project_name == "" or project_dir == "" then
		reaper.ShowMessageBox("Please save the project first", "Error", 0)
		return
	end
	return project_name, project_dir
end

function path.get_script_file_name()
    return debug.getinfo(1, 'S').source:sub(2):gsub('-jacques', '')
end

function path.generate_unique_timestamp()
	local jacques_year = 1989
	local jacques_month = 10
	local jacques_day = 11
	-- get current day and month
	local current_day = tonumber(os.date("%d"))
	local current_month = tonumber(os.date("%m"))
	local current_year = tonumber(os.date("%Y"))
	
	-- calculate age
	local age = current_year - jacques_year
	if current_month < jacques_month or (current_month == jacques_month and current_day < jacques_day) then
		age = age - 1
	end


    local timestamp = os.date(age .. "%m%d_%H%M%S")
    return timestamp
end

function path.get_file_name(file)
	-- Remove the directory path from the file_path using the last directory separator "/"
	local file_name = file:match(".*/(.+)")
	-- Remove the extension from the basename
	file_name = file_name:match("(.+)%..+")
	return file_name
end

return path