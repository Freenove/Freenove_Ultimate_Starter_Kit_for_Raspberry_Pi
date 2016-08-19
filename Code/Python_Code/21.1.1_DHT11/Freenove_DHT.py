#############################################################################
# Filename    : Freenove_DHT.py
# Description :	DHT Temperature & Humidity Sensor library for Raspberry
# Author      : freenove
# modification: 2016/07/11
########################################################################
import RPi.GPIO as GPIO
import time

class DHT(object):
	DHTLIB_OK = 0
	DHTLIB_ERROR_CHECKSUM = -1
	DHTLIB_ERROR_TIMEOUT = -2
	DHTLIB_INVALID_VALUE = -999
	
	DHTLIB_DHT11_WAKEUP = 0.018		#18ms
	DHTLIB_TIMEOUT = 0.0001			#100us
	
	humidity = 0
	temperature = 0
	
	def __init__(self,pin):
		self.pin = pin
		self.bits = [0,0,0,0,0]
		GPIO.setmode(GPIO.BOARD)
	#Read DHT sensor, store the original data in bits[]	
	def readSensor(self,pin,wakeupDelay):
		mask = 0x80
		idx = 0
		self.bits = [0,0,0,0,0]
		GPIO.setup(pin,GPIO.OUT)
		GPIO.output(pin,GPIO.LOW)
		time.sleep(wakeupDelay)
		GPIO.output(pin,GPIO.HIGH)
		time.sleep(40*0.000001)
		GPIO.setup(pin,GPIO.IN)
		
		loopCnt = self.DHTLIB_TIMEOUT
		t = time.time()
		while(GPIO.input(pin) == GPIO.LOW):
			if((time.time() - t) > loopCnt):
				return self.DHTLIB_ERROR_TIMEOUT
		t = time.time()
		while(GPIO.input(pin) == GPIO.HIGH):
			if((time.time() - t) > loopCnt):
				return self.DHTLIB_ERROR_TIMEOUT
		for i in range(0,40,1):
			t = time.time()
			while(GPIO.input(pin) == GPIO.LOW):
				if((time.time() - t) > loopCnt):
					return self.DHTLIB_ERROR_TIMEOUT
			t = time.time()
			while(GPIO.input(pin) == GPIO.HIGH):
				if((time.time() - t) > loopCnt):
					return self.DHTLIB_ERROR_TIMEOUT		
			if((time.time() - t) > 0.00005):	
				self.bits[idx] |= mask
			#print"t : %f"%(time.time()-t)
			mask >>= 1
			if(mask == 0):
				mask = 0x80
				idx += 1	
		GPIO.setup(pin,GPIO.OUT)
		GPIO.output(pin,GPIO.HIGH)
		return self.DHTLIB_OK
	#Read DHT sensor, analyze the data of temperature and humidity
	def readDHT11(self,pin):
		
		rv = self.readSensor(pin,self.DHTLIB_DHT11_WAKEUP)
		if (rv is not self.DHTLIB_OK):
			self.humidity = self.DHTLIB_INVALID_VALUE
			self.temperature = self.DHTLIB_INVALID_VALUE
			return rv
		self.humidity = self.bits[0]
		self.temperature = self.bits[2]
		sumChk = ((self.bits[0] + self.bits[2]) & 0xff)
		if(self.bits[4] is not sumChk):
			return self.DHTLIB_ERROR_CHECKSUM
		return self.DHTLIB_OK
		
def loop():
	dht = DHT(11)
	sumCnt = 0
	okCnt = 0
	while(True):
		sumCnt += 1
		chk = dht.readDHT11(11)	
		if (chk is 0):
			okCnt += 1		
		okRate = 100.0*okCnt/sumCnt;
		print"sumCnt : %d, \t okRate : %.2f%% "%(sumCnt,okRate)		
		print"chk : %d, \t Humidity : %.2f, \t Temperature : %.2f "%(chk,dht.humidity,dht.temperature)		
		time.sleep(1)		
		
if __name__ == '__main__':
	print 'Program is starting ... '
	try:
		loop()
	except KeyboardInterrupt:
		pass
		exit()		
		
		
