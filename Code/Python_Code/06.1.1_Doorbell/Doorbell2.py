#!/usr/bin/env python3
########################################################################
# Filename    : Doorbell.py
# Description : Make doorbell with buzzer and button
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
from gpiozero import LED, Button
from signal import pause

print ('Program is starting...')

led = LED(17)
button = Button(18)

def onButtonPressed():
    led.on()
    print("Button is pressed, led turned on >>>")
    
def onButtonReleased():
    led.off()
    print("Button is released, led turned on <<<")

button.when_pressed = onButtonPressed
button.when_released = onButtonReleased

pause()

