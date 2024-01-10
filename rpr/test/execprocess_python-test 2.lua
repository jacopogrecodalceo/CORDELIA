local command = 'cd /Users/j/Documents/PROJECTs/CORDELIA/_cordelia && /opt/homebrew/bin/python3 cordelia.py -s "/Users/j/Documents/PROJECTs/ateliers_hiver/_session/_extra/cutij_possible-cordelia_render/01-plumk/cutij_possible-01-plumk.sco"'
--reaper.ExecProcess(command, 0)
os.execute(command)
--[[ 
local handle = io.popen(command)
local output = handle:read('*a')
reaper.ShowConsoleMsg(output) ]]