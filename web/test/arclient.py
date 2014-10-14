import socket
import time

if __name__ == '__main__':
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.connect(('localhost', 8003))
	for x in range(10):
		sock.send('haha')
		time.sleep(1)
	sock.close()
