import threading
import socket
import time
import datetime

def ArComEnc(cmd, arg, cot):
	cm = [str(cot), cmd] + arg + [str(len(arg))]
	return ' '.join(ck) + ';'

def ArComDec(msg):
	if msg[-1] != ';':
		pass # throw EXCEPT
	cm = msg.split(';')
	ret = []
	for x in cm:
		if x != '':
			try:
				cw = x.split(' ')
				cnt = int(cw[0])
				cmd = cw[1]
				arg = cw[2:-1]
				args = int(cw[-1])
				if args != len(arg):
					raise ValueError('Invalid Cmd')
				ret.append((cnt, cmd, arg))
			except Exception:
				raise ValueError('Invalid Cmd')
	return ret

def ArHeartBeatGen():
	ts = int(time.mktime(datetime.datetime.utcnow().utctimetuple()))
	return '0 HB ' + str(ts) + ' 1;';
	

class TaskPender:
	def __init__(self):
		self.task = ('.EMPTY', -1)
		self.count = 0
		self.mutex = threading.Lock()
	def set(self, cmd, arg):
		if self.mutex.acquire():
			self.task = (ArComEnc(cmd, arg, count), count)
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
		# ArComDec(msg)
		# send MSG
		tsk = self.task.get()
		if not tsk[-1] < 0:
			self.conn.send(tsk[0])
			print '[SEND] %s' % tsk[0]
		else:
			cmhb = ArHeartBeatGen()
			self.conn.send(cmhb)
			print '[SEND] %s' % cmhb
	# CONTROL interfaces for main thread --below
	def ar_takeoff(self):
		pass
	def ar_land(self):
		pass
	def ar_flyH(self):
		pass
	def ar_flyV(self):
		pass
	def ar_turn(self):
		pass
	def ar_getstatus(self):
		pass

if __name__ == '__main__':
	ac = ArCommander(8000, 10, 0.2)
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
