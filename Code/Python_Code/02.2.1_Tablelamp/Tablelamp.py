#!/usr/bin/env python3
########################################################################
# Filename    : Tablelamp.py
# Description : a DIY MINI table lamp
# auther      : www.freenove.com
# modification: 2019/12/28
########################################################################
import RPi.GPIO as GPIO

ledPin = 11       # define ledPin
buttonPin = 12    # define buttonPin
ledState = False

def setup():    
    GPIO.setmode(GPIO.BOARD)         # use PHYSICAL GPIO Numbering
    GPIO.setup(ledPin, GPIO.OUT)     # set ledPin to OUTPUT mode
    GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)     # set buttonPin to PULL UP INPUT mode

def buttonEvent(channel): # When button is pressed, this function will be executed
    global ledState 
    print ('buttonEvent GPIO%d' %channel)
    ledState = not ledState
    if ledState :
        print ('Led turned on >>>')
    else :
        print ('Led turned off <<<')
    GPIO.output(ledPin,ledState)
    
def loop():
    #Button detect 
    GPIO.add_event_detect(buttonPin,GPIO.FALLING,callback = buttonEvent,bouncetime=300)
    while True:
        pass
                
def destroy():
    GPIO.cleanup()                     # Release GPIO resource

if __name__ == '__main__':     # Program entrance
    print ('Program is starting...')
    setup()
    try:
        loop()
    except KeyboardInterrupt:  # Press ctrl-c to end the program.
        destroy()

