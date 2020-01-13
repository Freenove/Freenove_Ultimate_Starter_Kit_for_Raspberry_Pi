#!/usr/bin/env python3
########################################################################
# Filename    : Alertor.py
# Description : Make Alertor with buzzer and button
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
import RPi.GPIO as GPIO
import time
import math

buzzerPin = 11    # define the buzzerPin
buttonPin = 12    # define the buttonPin

def setup():
    global p    
    GPIO.setmode(GPIO.BOARD)         # Use PHYSICAL GPIO Numbering
    GPIO.setup(buzzerPin, GPIO.OUT)   # set RGBLED pins to OUTPUT mode
    GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)    # Set buttonPin to INPUT mode, and pull up to HIGH level, 3.3V
    p = GPIO.PWM(buzzerPin, 1) 
    p.start(0);
    
def loop():
    while True:
        if GPIO.input(buttonPin)==GPIO.LOW:
            alertor()
            print ('alertor turned on >>> ')
        else :
            stopAlertor()
            print ('alertor turned off <<<')
def alertor():
    p.start(50)
    for x in range(0,361):      # Make frequency of the alertor consistent with the sine wave 
        sinVal = math.sin(x * (math.pi / 180.0))        # calculate the sine value
        toneVal = 2000 + sinVal * 500   # Add to the resonant frequency with a Weighted
        p.ChangeFrequency(toneVal)      # Change Frequency of PWM to toneVal
        time.sleep(0.001)
        
def stopAlertor():
    p.stop()
            
def destroy():
    GPIO.output(buzzerPin, GPIO.LOW)     # Turn off buzzer
    GPIO.cleanup()                       # Release GPIO resource

if __name__ == '__main__':     # Program entrance
    print ('Program is starting...')
    setup()
    try:
        loop()
    except KeyboardInterrupt:  # Press ctrl-c to end the program.
        destroy()

