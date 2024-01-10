local command = '/opt/homebrew/bin/python3 /Users/j/Documents/PROJECTs/CORDELIA/rpr/test/cmd-sox.py'
reaper.ExecProcess(command, -2)
--os.execute(command)

--[[ local handle = io.popen(command)
local output = handle:read('*a')
reaper.ShowConsoleMsg(output) ]]