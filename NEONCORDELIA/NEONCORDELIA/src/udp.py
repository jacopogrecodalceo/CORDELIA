import socket, select
from config.const import UDP_PORTs, UDP_SOCKETs, UDP_SIZE

empty = []

def open_ports():
	for port, name in UDP_PORTs.items():
		server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		server_socket.bind(('localhost', port))
		print(f'Port {name} open @{port}')
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

def listen(message_queue):
	while True:
		direction, code = receive()
		message_queue.put((direction, code))
