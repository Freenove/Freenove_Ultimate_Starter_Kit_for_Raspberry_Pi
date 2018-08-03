#!/usr/bin/env python3
########################################################################
# Filename    : Alertor.py
# Description : Alarm by button.
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import time
import math

buzzerPin = 11    # define the buzzerPin
buttonPin = 12    # define the buttonPin

def setup():
	global p
	print ('Program is starting...')
	GPIO.setmode(GPIO.BOARD)       # Numbers GPIOs by physical location
	GPIO.setup(buzzerPin, GPIO.OUT)   # Set buzzerPin's mode is output
	GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)    # Set buttonPin's mode is input, and pull up to high level(3.3V)
	p = GPIO.PWM(buzzerPin, 1)
	p.start(0);
	
def loop():
	while True:
		if GPIO.input(buttonPin)==GPIO.LOW:
			alertor()
			print ('buzzer on ...')
		else :
			stopAlertor()
			print ('buzzer off ...')
def alertor():
	p.start(50)
	for x in range(0,361):		#frequency of the alarm along the sine wave change
		sinVal = math.sin(x * (math.pi / 180.0))		#calculate the sine value
		toneVal = 2000 + sinVal * 500	#Add to the resonant frequency with a Weighted
		p.ChangeFrequency(toneVal)		#output PWM
		time.sleep(0.001)
		
def stopAlertor():
	p.stop()
			
def destroy():
	GPIO.output(buzzerPin, GPIO.LOW)     # buzzer off
	GPIO.cleanup()                     # Release resource

if __name__ == '__main__':     # Program start from here
	setup()
	try:
		loop()
	except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.
		destroy()

