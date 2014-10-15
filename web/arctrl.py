import threading
import socket
import time
import inspect  
import ctypes  
 
class TaskPender:
	def __init__(self):
		self.task = ('.EMPTY', -1)
		self.count = 0
		self.mutex = threading.Lock()
	def set(self, task_content):
		if self.mutex.acquire():
			self.task = (task_content, count)
			count += 1
			self.mutex.release()
	def get(self):
		return self.task
	def finish(self, taskid):
		if self.mutex.acquire():
			if self.task[-1] == taskid:
				self.task = ('.EMPTY', -1)
				res = True
			else:
				res = False
			self.mutex.release()
			return res
		else:
			return False

class ArCommander(threading.Thread):
	def __init__(self, port, timeout, freq):
		threading.Thread.__init__(self)
		self.port = port
		self.timeout = timeout
		self.freq = freq
		self.task = TaskPender()
		self.connection = False
		self.online = True
	def run(self):
		sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		sock.bind(('0.0.0.0', self.port))
		sock.listen(3)
		print 'ArCommander listening at %d' % self.port
		while self.online:
			self.conn, self.addr = sock.accept()
			print '%s:%d connected' % (self.addr[0], self.addr[-1])
			self.connection = True
			self.task = TaskPender()
			try:
				self.conn.settimeout(self.timeout)
				while self.online:
					buf = self.conn.recv(1024)
					print '[RECV] %s' % buf
					self.handleMsg(buf)
					time.sleep(self.freq)
			except socket.timeout:
				self.connection = False
				print '%s:%d timeout disconnected' % (self.addr[0], self.addr[-1])
			except Exception:
				self.connection = False
				print '%s:%d error disconnected' % (self.addr[0], self.addr[-1])
		print 'SOCKET THREAD EXITED'
	def stop(self):
		self.online = False
	def handleMsg(self, msg):
		# handle MSG
		# send MSG
		tsk = self.task.get()
		if not task[-1] < 0:
			self.conn.send(tsk)
			print '[SEND] %s' % tsk[0]
		else:
			print '[SEND] HB'
	def send

if __name__ == '__main__':
	ac = ArCommander(8003, 10, 0.2)
	ac.setDaemon(True)
	ac.start()
	print 'type [stop] to stop'
	while True:
		cmd = raw_input()
		if cmd == 'stop':
			ac.stop()
			ac.join(1)
			print 'exited'
			break
		else:
			print 'type [stop] to stop'
