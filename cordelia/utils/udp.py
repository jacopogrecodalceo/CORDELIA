import socket, select
from pythonosc.udp_client import SimpleUDPClient

LOCALHOST = socket.gethostbyname(socket.gethostname())

UDP_PORTs = {
	10015: 'CORDELIA',
	10000: 'CSOUND',
	10025: 'REAPER',
}

UDP_SOCKETs = []
UDP_SIZE = 4096

empty = []

def open_ports():
	for port, name in UDP_PORTs.items():
		server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		server_socket.bind(('localhost', port))
		print(f'Port {name} open@{port}')
		UDP_SOCKETs.append(server_socket)

def receive() -> tuple():
	readable, writable, exceptional = select.select(UDP_SOCKETs, empty, empty)
	for s in readable:

		message, _address = s.recvfrom(UDP_SIZE)
		if not message:
			break

		# get where the message comes from
		_host, port = s.getsockname()
		direction = UDP_PORTs[port]
		#print(f"\n---I come from {direction}\n")
		# get UDP message

		return (direction, message.decode())

reaper_send = SimpleUDPClient(LOCALHOST, 8500)
def udpsend_reaper(message):
	reaper_send.send_message(message, None)

def listen(message_queue):
	while True:
		try:
			direction, code = receive()
			message_queue.put((direction, code))
		except:
			print("WARNING IN UDP")
			
