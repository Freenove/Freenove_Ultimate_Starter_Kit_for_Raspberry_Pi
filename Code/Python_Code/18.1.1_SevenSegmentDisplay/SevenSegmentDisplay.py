#!/usr/bin/env python3
#############################################################################
# Filename    : SevenSegmentDisplay.py
# Description : Control SevenSegmentDisplay by 74HC595
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import time

LSBFIRST = 1
MSBFIRST = 2
#define the pins connect to 74HC595
dataPin   = 11		#DS Pin of 74HC595(Pin14)
latchPin  = 13		#ST_CP Pin of 74HC595(Pin12)
clockPin = 15		#CH_CP Pin of 74HC595(Pin11)
#SevenSegmentDisplay display the character "0"- "F"successively
num = [0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,0x88,0x83,0xc6,0xa1,0x86,0x8e]
def setup():
	GPIO.setmode(GPIO.BOARD)    # Number GPIOs by its physical location
	GPIO.setup(dataPin, GPIO.OUT)
	GPIO.setup(latchPin, GPIO.OUT)
	GPIO.setup(clockPin, GPIO.OUT)
	
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
		for i in range(0,len(num)):
			GPIO.output(latchPin,GPIO.LOW)
			shiftOut(dataPin,clockPin,MSBFIRST,num[i])#Output the figures and the highest level is transfered preferentially.
			GPIO.output(latchPin,GPIO.HIGH)
			time.sleep(0.5)
		for i in range(0,len(num)):
			GPIO.output(latchPin,GPIO.LOW)
			shiftOut(dataPin,clockPin,MSBFIRST,num[i]&0x7f)#Use "&0x7f"to display the decimal point.
			GPIO.output(latchPin,GPIO.HIGH)
			time.sleep(0.5)

def destroy():   # When 'Ctrl+C' is pressed, the function is executed. 
	GPIO.cleanup()

if __name__ == '__main__': # Program starting from here 
	print ('Program is starting...' )
	setup() 
	try:
		loop()  
	except KeyboardInterrupt:  
		destroy()  
