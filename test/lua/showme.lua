-- Define the path to the log file and the number of characters to show
local temp_log_file = "/Users/j/Desktop/pipie/temp_log"
local show_size = 1024

-- Define the last time the function was called
local last_time = 0

-- Define the last size of the log file
local last_size = 0

-- Define the function to periodically read new output from the log file
function refreshLog()
  local time_elapsed = os.time()
  if (time_elapsed - last_time) >= 1 then
    local file = assert(io.open(temp_log_file, "rb")) -- open the file in binary mode
    local current_size = file:seek("end") -- get the current size of the file
    if current_size > last_size then -- check if there is new data to read
      file:seek("set", current_size - show_size) -- seek to the position of the new data
      local data = file:read(show_size) -- read the new data
      print(data)
    end
    file:close() -- close the file when done
    last_time = time_elapsed -- update the last time the function was called
    last_size = current_size -- update the last size of the file
  end
end

while true do
  refreshLog()
end
