#!/usr/bin/env python3
#############################################################################
# Filename    : ADC.py
# Description : ADC and DAC
# Author      : freenove
# modification: 2018/09/15
########################################################################
import smbus
import time

address = 0x48	#default address of PCF8591
bus=smbus.SMBus(1)
cmd=0x40		#command

def analogRead(chn):#read ADC value,chn:0,1,2,3
	value = bus.read_byte_data(address,cmd+chn)
	return value
	
def analogWrite(value):#write DAC value
	bus.write_byte_data(address,cmd,value)	
	
def loop():
	while True:
		value = analogRead(0)	#read the ADC value of channel 0
		analogWrite(value)		#write the DAC value
		voltage = value / 255.0 * 3.3  #calculate the voltage value
		print ('ADC Value : %d, Voltage : %.2f'%(value,voltage))
		time.sleep(0.01)

def destroy():
	bus.close()
	
if __name__ == '__main__':
	print ('Program is starting ... ')
	try:
		loop()
	except KeyboardInterrupt:
		destroy()
		
	
