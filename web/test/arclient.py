import socket
import time

if __name__ == '__main__':
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.connect(('localhost', 8000))
	while True:
		sock.send('haha')
		print sock.recv(1024)
		time.sleep(1)
	sock.close()
