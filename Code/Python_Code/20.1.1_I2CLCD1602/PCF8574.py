########################################################################
# Filename    : PCF8574.py
# Description : PCF8574 as Raspberry GPIO
# Author      : freenove
# modification: 2018/08/03
########################################################################
import smbus
import time
class PCF8574_I2C(object):
	OUPUT = 0
	INPUT = 1
	
	def __init__(self,address):
		# Note you need to change the bus number to 0 if running on a revision 1 Raspberry Pi.
		self.bus = smbus.SMBus(1)
		self.address = address
		self.currentValue = 0
		self.writeByte(0)	#I2C test.
		
	def readByte(self):#Read PCF8574 all port of the data
		#value = self.bus.read_byte(self.address)
		return self.currentValue#value
		
	def writeByte(self,value):#Write data to PCF8574 port
		self.currentValue = value
		self.bus.write_byte(self.address,value)

	def digitalRead(self,pin):#Read PCF8574 one port of the data
		value = readByte()	
		return (value&(1<<pin)==(1<<pin)) and 1 or 0
		
	def digitalWrite(self,pin,newvalue):#Write data to PCF8574 one port
		value = self.currentValue #bus.read_byte(address)
		if(newvalue == 1):
			value |= (1<<pin)
		elif (newvalue == 0):
			value &= ~(1<<pin)
		self.writeByte(value)	

def loop():
	mcp = PCF8574_I2C(0x27)
	while True:
		#mcp.writeByte(0xff)
		mcp.digitalWrite(3,1)
		print ('Is 0xff? %x'%(mcp.readByte()))
		time.sleep(1)
		mcp.writeByte(0x00)
		#mcp.digitalWrite(7,1)
		print ('Is 0x00? %x'%(mcp.readByte()))
		time.sleep(1)
		
class PCF8574_GPIO(object):#Standardization function interface
	OUT = 0
	IN = 1
	BCM = 0
	BOARD = 0
	def __init__(self,address):
		self.chip = PCF8574_I2C(address)
		self.address = address
	def setmode(self,mode):#PCF8574 port belongs to two-way IO, do not need to set the input and output model
		pass
	def setup(self,pin,mode):
		pass
	def input(self,pin):#Read PCF8574 one port of the data
		return self.chip.digitalRead(pin)
	def output(self,pin,value):#Write data to PCF8574 one port
		self.chip.digitalWrite(pin,value)
		
def destroy():
	bus.close()
	
if __name__ == '__main__':
	print ('Program is starting ... ')
	try:
		loop()
	except KeyboardInterrupt:
		destroy()
		
	
