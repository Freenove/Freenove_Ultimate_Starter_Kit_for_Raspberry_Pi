#!/usr/bin/env python3
########################################################################
# Filename    : Tablelamp.py
# Description : DIY MINI table lamp
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
from gpiozero import LED, Button
from signal import pause

print ('Program is starting ... ')

led = LED(17) # define LED pin according to BCM Numbering
button = Button(18) # define Button pin according to BCM Numbering

def onButtonPressed():
    led.toggle()
    if led.is_lit :
        print("Led turned on >>>")
    else :
        print("Led turned off <<<")

button.when_pressed = onButtonPressed

pause()
