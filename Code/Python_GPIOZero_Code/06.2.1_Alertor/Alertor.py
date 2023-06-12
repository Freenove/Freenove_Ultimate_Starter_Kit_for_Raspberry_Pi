#!/usr/bin/env python3
########################################################################
# Filename    : Alertor.py
# Description : Make Alertor with buzzer and button
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
from gpiozero import TonalBuzzer,Button
from gpiozero.tones import Tone
import time
import math

buzzer = TonalBuzzer(17)
button = Button(18) # define Button pin according to BCM Numbering

def loop():
    while True:
        if button.is_pressed:  # if button is pressed
            alertor()
            print ('alertor turned on >>> ')
        else :
            stopAlertor()
            print ('alertor turned off <<<')
def alertor():
    for x in range(0,361):      # Make frequency of the alertor consistent with the sine wave 
        sinVal = math.sin(x * (math.pi / 180.0))        # calculate the sine value
        toneVal = 2000 + sinVal * 500   # Add to the resonant frequency with a Weighted
        b.play(Tone(toneVal))  # Change Frequency of PWM to toneVal
        time.sleep(0.001)
        
def stopAlertor():
    buzzer.stop()
            
def destroy():
    buzzer.close()                  

if __name__ == '__main__':     # Program entrance
    print ('Program is starting...')
    try:
        loop()
    except KeyboardInterrupt:  # Press ctrl-c to end the program.
        destroy()
        print("Ending program")