import socket

HOST = 'localhost'
PORT = 7777

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
s.send('START_PIPELINE')
data = s.recv(1024)
s.close()
print 'Received', repr(data)