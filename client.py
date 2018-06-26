import socket

HOST = 'localhost'
PORT = 7777

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
s.send('START_PIPELINE')
while 1:
	data = s.recv(1024)
	print 'Received', repr(data)