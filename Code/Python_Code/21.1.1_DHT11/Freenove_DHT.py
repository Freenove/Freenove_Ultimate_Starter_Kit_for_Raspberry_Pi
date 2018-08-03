#!/usr/bin/env python3
#############################################################################
# Filename    : Freenove_DHT.py
# Description :	DHT Temperature & Humidity Sensor library for Raspberry
# Author      : freenove
# modification: 2018/08/03
########################################################################
import RPi.GPIO as GPIO
import time

class DHT(object):
	DHTLIB_OK = 0
	DHTLIB_ERROR_CHECKSUM = -1
	DHTLIB_ERROR_TIMEOUT = -2
	DHTLIB_INVALID_VALUE = -999
	
	DHTLIB_DHT11_WAKEUP = 0.020#0.018		#18ms
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
		#time.sleep(40*0.000001)
		GPIO.setup(pin,GPIO.IN)
		
		loopCnt = self.DHTLIB_TIMEOUT
		t = time.time()
		while(GPIO.input(pin) == GPIO.LOW):
			if((time.time() - t) > loopCnt):
				#print ("Echo LOW")
				return self.DHTLIB_ERROR_TIMEOUT
		t = time.time()
		while(GPIO.input(pin) == GPIO.HIGH):
			if((time.time() - t) > loopCnt):
				#print ("Echo HIGH")
				return self.DHTLIB_ERROR_TIMEOUT
		for i in range(0,40,1):
			t = time.time()
			while(GPIO.input(pin) == GPIO.LOW):
				if((time.time() - t) > loopCnt):
					#print ("Data Low %d"%(i))
					return self.DHTLIB_ERROR_TIMEOUT
			t = time.time()
			while(GPIO.input(pin) == GPIO.HIGH):
				if((time.time() - t) > loopCnt):
					#print ("Data HIGH %d"%(i))
					return self.DHTLIB_ERROR_TIMEOUT		
			if((time.time() - t) > 0.00005):	
				self.bits[idx] |= mask
			#print("t : %f"%(time.time()-t))
			mask >>= 1
			if(mask == 0):
				mask = 0x80
				idx += 1	
		#print (self.bits)
		GPIO.setup(pin,GPIO.OUT)
		GPIO.output(pin,GPIO.HIGH)
		return self.DHTLIB_OK
	#Read DHT sensor, analyze the data of temperature and humidity
	def readDHT11(self):
		rv = self.readSensor(self.pin,self.DHTLIB_DHT11_WAKEUP)
		if (rv is not self.DHTLIB_OK):
			self.humidity = self.DHTLIB_INVALID_VALUE
			self.temperature = self.DHTLIB_INVALID_VALUE
			return rv
		self.humidity = self.bits[0]
		self.temperature = self.bits[2] + self.bits[3]*0.1
		sumChk = ((self.bits[0] + self.bits[1] + self.bits[2] + self.bits[3]) & 0xFF)
		if(self.bits[4] is not sumChk):
			return self.DHTLIB_ERROR_CHECKSUM
		return self.DHTLIB_OK
		
def loop():
	dht = DHT(11)
	sumCnt = 0
	okCnt = 0
	while(True):
		sumCnt += 1
		chk = dht.readDHT11()	
		if (chk is 0):
			okCnt += 1		
		okRate = 100.0*okCnt/sumCnt;
		print("sumCnt : %d, \t okRate : %.2f%% "%(sumCnt,okRate))
		print("chk : %d, \t Humidity : %.2f, \t Temperature : %.2f "%(chk,dht.humidity,dht.temperature))
		time.sleep(3)		
		
if __name__ == '__main__':
	print ('Program is starting ... ')
	try:
		loop()
	except KeyboardInterrupt:
		pass
		exit()		
		
		
