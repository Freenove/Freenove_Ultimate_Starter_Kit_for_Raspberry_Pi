#!/usr/bin/env python3
########################################################################
# Filename    : Relay.py
# Description : Control Relay and Motor via Button 
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
import RPi.GPIO as GPIO
import time

relayPin = 11     # define the relayPin
buttonPin = 12    # define the buttonPin
debounceTime = 50

def setup():    
    GPIO.setmode(GPIO.BOARD)       
    GPIO.setup(relayPin, GPIO.OUT)   # set relayPin to OUTPUT mode
    GPIO.setup(buttonPin, GPIO.IN)   # set buttonPin to INTPUT mode

def loop():
    relayState = False
    lastChangeTime = round(time.time()*1000)
    buttonState = GPIO.HIGH
    lastButtonState = GPIO.HIGH
    reading = GPIO.HIGH
    while True:
        reading = GPIO.input(buttonPin)     
        if reading != lastButtonState :
            lastChangeTime = round(time.time()*1000)
        if ((round(time.time()*1000) - lastChangeTime) > debounceTime):
            if reading != buttonState :
                buttonState = reading;
                if buttonState == GPIO.LOW:
                    print("Button is pressed!")
                    relayState = not relayState
                    if relayState:
                        print("Turn on relay ...")
                    else :
                        print("Turn off relay ... ")
                else :
                    print("Button is released!")
        GPIO.output(relayPin,relayState)
        lastButtonState = reading # lastButtonState store latest state
    
def destroy():
    GPIO.cleanup()                      

if __name__ == '__main__':     # Program entrance
    print ('Program is starting...')
    setup()
    try:
        loop()
    except KeyboardInterrupt:   # Press ctrl-c to end the program.
        destroy()

