import threading
import socket
import time
import datetime

def ArComEnc(cmd, arg, cot):
	cm = [str(cot), cmd] + arg + [str(len(arg))]
	return ' '.join(ck) + ';'

def ArComDec(msg):
	if msg[-1] != ';':
		print '[ERR] MSG cannot be recognized.'
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
					print 'ARComDec len VE'
					raise ValueError('Invalid Cmd')
				ret.append((cnt, cmd, arg))
			except Exception:
				print 'ARCD VE'
				raise ValueError('Invalid Cmd')
	return ret

def ArHeartBeatGen():
	ts = int(time.mktime(datetime.datetime.utcnow().utctimetuple()))
	return '0 HB ' + str(ts) + ' 1;'

class TaskPender:
	def __init__(self):
		self.task = ('.EMPTY', -1)
		self.count = 0
		self.queue = {}
		self.mutex = threading.Lock()
	def set(self, cmd, arg):
		if self.mutex.acquire():
			self.task = (ArComEnc(cmd, arg, count), count)
			count += 1
			self.mutex.release()
			return count
	def get(self):
		if self.mutex.acquire():
			ret = self.task
			if ret[1] < 0:
				self.mutex.release()
				return ret
			if ret[0].split(' ')[1] == 'RES':
				self.task = ('.EMPTY', -1)
			elif ret[1] not in self.queue:
				self.queue[ret[1]] = ret[0]
			self.mutex.release()
			return ret
		return self.task
	def get_history_pending(self, taskid):
		if taskid in self.queue:
			return self.queue[taskid]
		else:
			return '.ERROR'
	def finish(self, taskid):
		if taskid in self.queue:
			del self.queue[taskid]
			return True
		else:
			return False

class ArSocketer(threading.Thread):
	def __init__(self, port, timeout, freq, actor):
		threading.Thread.__init__(self)
		self.port = port
		self.timeout = timeout
		self.freq = freq
		self.actor = actor
		self.task = TaskPender()
		self.connection = False
		self.online = True
	def run(self):
		sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		sock.bind(('0.0.0.0', self.port))
		sock.listen(3)
		print 'ArSocketer listening at %d' % self.port
		while self.online:
			self.conn, self.addr = sock.accept()
			print '%s:%d connected' % (self.addr[0], self.addr[-1])
			self.connection = True
			self.task = TaskPender()
			self.actor([(-1, 'onconnect', self.addr)])
			try:
				self.conn.settimeout(self.timeout)
				self.conn.send(ArHeartBeatGen())
				print '8000 OnConnect HB sent'
				while self.online:
					buf = self.conn.recv(1024)
					print '[%d RECV] %s' % (self.port, buf)
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
		print 'start hand msg'
		self.actor(ArComDec(msg))
		# send MSG
		print 'start send msg'
		tsk = self.task.get()
		print tsk
		if not tsk[-1] < 0:
			print 'send task'
			self.conn.send(tsk[0])
			print '[%d SEND] %s' % (self.port, tsk[0])
		else:
			cmhb = ArHeartBeatGen()
			print 'send hb %s' % cmhb
			self.conn.send(cmhb)
			print '[%d SEND] %s' % (self.port, cmhb)

class ArCommander:
	def __init__(self, port, timeout, freq, actor):
		self.sock = ArSocketer(port, timeout, freq, actor)
		self.sock.setDaemon(True)
	def start(self):
		self.sock.start()
	# CONTROL interfaces for main thread --below
	def ar_takeoff(self):
		self.sock.task.set('TAO', [])
	def ar_land(self):
		self.sock.task.set('LAD', [])
	def ar_hover(self):
		self.sock.task.set('HOV', [])
	def ar_flyH(self, speed, dtime):
		self.sock.task.set('FLY', [speed, dtime])
	def ar_flyV(self, speed, dtime):
		self.sock.task.set('DIR', [speed, dtime])
	def ar_turn(self, speed, dtime):
		self.sock.task.set('HEI', [speed, dtime])
	def ar_getstatus(self):
		self.sock.task.set('QRS', [])

class ArOutsideCommander:
	def __init__(self, port, timeout, freq, actor):
		self.sock = ArSocketer(port, timeout, freq, actor)
		self.sock.setDaemon(True)
		self.actor = actor
		self.signed = False
	def start(self):
		self.sock.start()
	def askfor_sign(self):
		self.sock.task.set('USR', [])
	def pass_sign(self):
		self.sock.task.set('RES',['USR', 0, 'SUC'])
	# CONTROL interfaces for main thread --below

def ArControllerSign(uname, upass):
	if (upass == 'ArDrone'):
		return True
	else:
		return False

if __name__ == '__main__':
	print 'type [stop] to stop'
	def arc_act(msglist):
		for m in msglist:
			if m[1] == 'RES':
				pass
	def aro_act(msglist):
		for m in msglist:
			if m[1] == 'onconnect':
				aro.signed = False
				aro.askfor_sign()
			if m[1] == 'RES' and m[2][1] == 'USR': # ....
				aro.signed = True
				aro.pass_sign()
			if aro.signed == True:
				# pass msg to arc
				pass
	arc = ArCommander(8080, 10, 0.1, arc_act)
	aro = ArOutsideCommander(8001, 10, 0.1, aro_act)
	arc.start()
	aro.start()
	while True:
		cmd = raw_input()
		if cmd == 'stop':
			arc.sock.stop()
			arc.sock.join(1)
			aro.sock.stop()
			aro.sock.join(1)
			print 'exited'
			break
		if cmd == 'arc':
			while arc.sock.connection == True:
				cwd = raw_input()
				if cwd == 'stop':
					break
				elif cwd == 'takeoff':
					arc.ar_takeoff()
				elif cwd == 'land':
					arc.ar_land()
				elif cwd == 'hover':
					arc.ar_hover()
				elif cwd == 'getstatus':
					arc.ar_getstatus()
				elif cwd == 'flyh':
					arc.ar_flyH(0.5, 0.2)
				elif cwd == 'flyv':
					arc.ar_flyV(0.5, 0.2)
				elif cwd == 'turn':
					arc.ar_turn(0.5, 0.2)
			else:
				print 'ArCommander not ready'
		else:
			print 'type [stop] to stop'
