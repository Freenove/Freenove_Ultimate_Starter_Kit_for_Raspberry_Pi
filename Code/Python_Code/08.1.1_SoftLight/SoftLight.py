#!/usr/bin/env python3
#############################################################################
# Filename    : Softlight.py
# Description : Potentiometer control LED
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import smbus
import time

address = 0x48
bus=smbus.SMBus(1)
cmd=0x40
ledPin = 11

def analogRead(chn):
	value = bus.read_byte_data(address,cmd+chn)
	return value
	
def analogWrite(value):
	bus.write_byte_data(address,cmd,value)	

def setup():
	global p
	GPIO.setmode(GPIO.BOARD)
	GPIO.setup(ledPin,GPIO.OUT)
	GPIO.output(ledPin,GPIO.LOW)
	
	p = GPIO.PWM(ledPin,1000)
	p.start(0)
	
def loop():
	while True:
		value = analogRead(0)		#read A0 pin 
		p.ChangeDutyCycle(value*100/255)		#Convert ADC value to duty cycle of PWM 
		voltage = value / 255.0 * 3.3			#calculate voltage
		print ('ADC Value : %d, Voltage : %.2f'%(value,voltage))
		time.sleep(0.01)

def destroy():
	bus.close()
	GPIO.cleanup()
	
if __name__ == '__main__':
	print ('Program is starting ... ')
	setup()
	try:
		loop()
	except KeyboardInterrupt:
		destroy()
		
	
