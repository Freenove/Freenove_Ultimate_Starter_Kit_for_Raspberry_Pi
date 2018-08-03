#!/usr/bin/env python3
#############################################################################
# Filename    : LightWater02.py
# Description : Control LED by 74HC595
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import time
#Defines the data bit that is transmitted preferentially in the shiftOut function.
LSBFIRST = 1
MSBFIRST = 2
#define the pins connect to 74HC595
dataPin   = 11		#DS Pin of 74HC595(Pin14)
latchPin  = 13		#ST_CP Pin of 74HC595(Pin12)
clockPin = 15		#CH_CP Pin of 74HC595(Pin11)

def setup():
	GPIO.setmode(GPIO.BOARD)    # Number GPIOs by its physical location
	GPIO.setup(dataPin, GPIO.OUT)
	GPIO.setup(latchPin, GPIO.OUT)
	GPIO.setup(clockPin, GPIO.OUT)
#shiftOut function, use bit serial transmission. 
def shiftOut(dPin,cPin,order,val):
	for i in range(0,8):
		GPIO.output(cPin,GPIO.LOW);
		if(order == LSBFIRST):
			GPIO.output(dPin,(0x01&(val>>i)==0x01) and GPIO.HIGH or GPIO.LOW)
		elif(order == MSBFIRST):
			GPIO.output(dPin,(0x80&(val<<i)==0x80) and GPIO.HIGH or GPIO.LOW)
		GPIO.output(cPin,GPIO.HIGH);

def loop():
	while True:
		x=0x01
		for i in range(0,8):
			GPIO.output(latchPin,GPIO.LOW)	#Output low level to latchPin
			shiftOut(dataPin,clockPin,LSBFIRST,x)#Send serial data to 74HC595
			GPIO.output(latchPin,GPIO.HIGH)#Output high level to latchPin, and 74HC595 will update the data to the parallel output port.
			x<<=1# make the variable move one bit to left once, then the bright LED move one step to the left once.
			time.sleep(0.1)
		x=0x80
		for i in range(0,8):
			GPIO.output(latchPin,GPIO.LOW)
			shiftOut(dataPin,clockPin,LSBFIRST,x)
			GPIO.output(latchPin,GPIO.HIGH)
			x>>=1
			time.sleep(0.1)

def destroy():   # When 'Ctrl+C' is pressed, the function is executed. 
	GPIO.cleanup()

if __name__ == '__main__': # Program starting from here 
	print ('Program is starting...' )
	setup() 
	try:
		loop()  
	except KeyboardInterrupt:  
		destroy()  
