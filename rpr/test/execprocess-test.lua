local command = '/bin/echo "hello" >> /Users/j/Desktop/1.txt'
reaper.ExecProcess(command, -1)
--io.popen(command)