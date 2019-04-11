#!/usr/bin/env python3
########################################################################
# Filename    : LightWater.py
# Description : Display 10 LEDBar Graph
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import time

ledPins = [11, 12, 13, 15, 16, 18, 22, 3, 5, 24]

def setup():
	print ('Program is starting...')
	GPIO.setmode(GPIO.BOARD)        # Numbers GPIOs by physical location
	for pin in ledPins:
		GPIO.setup(pin, GPIO.OUT)   # Set all ledPins' mode is output
		GPIO.output(pin, GPIO.HIGH) # Set all ledPins to high(+3.3V) to off led

def loop():
	while True:
		for pin in ledPins:		#make led on from left to right
			GPIO.output(pin, GPIO.LOW)	
			time.sleep(0.1)
			GPIO.output(pin, GPIO.HIGH)
		for pin in ledPins[::-1]:		#make led on from right to left
			GPIO.output(pin, GPIO.LOW)	
			time.sleep(0.1)
			GPIO.output(pin, GPIO.HIGH)

def destroy():
	for pin in ledPins:
		GPIO.output(pin, GPIO.HIGH)    # turn off all leds
	GPIO.cleanup()                     # Release resource

if __name__ == '__main__':     # Program start from here
	setup()
	try:
		loop()
	except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.
		destroy()

