#!/usr/bin/env python3
########################################################################
# Filename    : Tablelamp.py
# Description : a DIY MINI table lamp
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO

ledPin = 11    # define the ledPin
buttonPin = 12    # define the buttonPin
ledState = False

def setup():
	print ('Program is starting...')
	GPIO.setmode(GPIO.BOARD)       # Numbers GPIOs by physical location
	GPIO.setup(ledPin, GPIO.OUT)   # Set ledPin's mode is output
	GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)    # Set buttonPin's mode is input, and pull up to high

def buttonEvent(channel):#When the button is pressed, this function will be executed
	global ledState 
	print ('buttonEvent GPIO%d' %channel)
	ledState = not ledState
	if ledState :
		print ('Turn on LED ... ')
	else :
		print ('Turn off LED ... ')
	GPIO.output(ledPin,ledState)
	
def loop():
	#Button detect 
	GPIO.add_event_detect(buttonPin,GPIO.FALLING,callback = buttonEvent,bouncetime=300)
	while True:
		pass
				
def destroy():
	GPIO.output(ledPin, GPIO.LOW)     # led off
	GPIO.cleanup()                     # Release resource

if __name__ == '__main__':     # Program start from here
	setup()
	try:
		loop()
	except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.
		destroy()

