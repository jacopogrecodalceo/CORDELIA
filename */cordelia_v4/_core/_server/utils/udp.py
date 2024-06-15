import socket, select
from utils.constants import CORDELIA_PORTs, CORDELIA_SOCKETs

def open_ports():
	for port, name in CORDELIA_PORTs.items():
		server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		server_socket.bind(('localhost', port))
		print(f"Hello {name}")
		CORDELIA_SOCKETs.append(server_socket)


UDP_size = 4096
empty = []

def receive_messages() -> tuple():
	readable, writable, exceptional = select.select(CORDELIA_SOCKETs, empty, empty)
	for s in readable:

		message, _address = s.recvfrom(UDP_size)
		if not message:
			break

		# get where the message comes from
		_host, port = s.getsockname()
		direction = CORDELIA_PORTs[port]
		#print(f"\n---I come from {direction}\n")
		# get UDP message

		return (direction, message.decode())


from pythonosc.udp_client import SimpleUDPClient
local_ip = socket.gethostbyname(socket.gethostname())
client = SimpleUDPClient(local_ip, 8500)
def send_message_reaper(message):
	client.send_message(message, ' ')

