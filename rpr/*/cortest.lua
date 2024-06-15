dofile( reaper.GetResourcePath() ..
   "/Scripts/Mavriq ReaScript Repository/Various/Mavriq-Lua-Batteries/batteries_header.lua")

function log(message)
	reaper.ShowConsoleMsg(tostring(message) .. "\n")
end

local socket = require('socket')

-- Create a new UDP socket using AF_INET as the address family and SOCK_DGRAM as the socket type
local s = socket.udp()

-- Define the destination host and port
local host = "localhost"
local port = 10025

function send_to_csound(message)

	-- Encode the message as a byte string before sending
	s:sendto(message, socket.dns.toip('localhost'), 10025)
	log(message)

end

send_to_csound('print 1')