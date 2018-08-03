#!/usr/bin/env python3
########################################################################
# Filename    : ButtonLED.py
# Description : Controlling an led by button.
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO

ledPin = 11    # define the ledPin
buttonPin = 12    # define the buttonPin

def setup():
	print ('Program is starting...')
	GPIO.setmode(GPIO.BOARD)       # Numbers GPIOs by physical location
	GPIO.setup(ledPin, GPIO.OUT)   # Set ledPin's mode is output
	GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)    # Set buttonPin's mode is input, and pull up to high level(3.3V)

def loop():
	while True:
		if GPIO.input(buttonPin)==GPIO.LOW:
			GPIO.output(ledPin,GPIO.HIGH)
			print ('led on ...')
		else :
			GPIO.output(ledPin,GPIO.LOW)
			print ('led off ...')		

def destroy():
	GPIO.output(ledPin, GPIO.LOW)     # led off
	GPIO.cleanup()                     # Release resource

if __name__ == '__main__':     # Program start from here
	setup()
	try:
		loop()
	except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.
		destroy()

