#!/usr/bin/env python3
########################################################################
# Filename    : Relay.py
# Description : Button control Relay and Motor
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO

relayPin = 11    # define the relayPin
buttonPin = 12    # define the buttonPin
relayState = False

def setup():
	print ('Program is starting...')
	GPIO.setmode(GPIO.BOARD)       # Numbers GPIOs by physical location
	GPIO.setup(relayPin, GPIO.OUT)   # Set relayPin's mode is output
	GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)    # Set buttonPin's mode is input, and pull up to high

def buttonEvent(channel):
	global relayState 
	print ('buttonEvent GPIO%d'%channel)
	relayState = not relayState
	if relayState :
		print ('Turn on relay ... ')
	else :
		print ('Turn off relay ... ')
	GPIO.output(relayPin,relayState)
	
def loop():
	#Button detect 
	GPIO.add_event_detect(buttonPin,GPIO.FALLING,callback = buttonEvent,bouncetime=300)
	while True:
		pass
	
def destroy():
	GPIO.output(relayPin, GPIO.LOW)     # relay off
	GPIO.cleanup()                     # Release resource

if __name__ == '__main__':     # Program start from here
	setup()
	try:
		loop()
	except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.
		destroy()

