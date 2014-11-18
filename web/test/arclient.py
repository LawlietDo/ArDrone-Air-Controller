import socket
import time
import datetime

def ArHeartBeatGen():
	ts = int(time.mktime(datetime.datetime.utcnow().utctimetuple()))
	return '0 HB ' + str(ts) + ' 1;'

if __name__ == '__main__':
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.connect(('172.18.187.115', 8080))
	while True:
		print sock.recv(1024)
		time.sleep(1)
		sock.send(ArHeartBeatGen())
	sock.close()
