#!/usr/bin/env python3
########################################################################
# Filename    : LightWater.py
# Description : Use LEDBar Graph(10 LED) 
# Author      : www.freenove.com
# modification: 2023/05/11
########################################################################
from gpiozero import LEDBoard
from time import sleep

#ledPins = ["J8:11", "J8:12","J8:13","J8:15","J8:16","J8:18","J8:22","J8:3","J8:5","J8:24"]
ledPins = [17, 18, 27, 22, 23, 24, 25, 2, 3, 8]

leds = LEDBoard(*ledPins, active_high=False)

def loop():
    while True:
        for index in range(0,len(ledPins),1):      # make led(on) move from left to right
            leds.on(index)  
            sleep(0.1)
            leds.off(index)
        for index in range(len(ledPins)-1,-1,-1):   #move led(on) from right to left
            leds.on(index)      
            sleep(0.1)
            leds.off(index)

if __name__ == '__main__':     # Program entrance
    print ('Program is starting...')
    try:
        loop()
    except KeyboardInterrupt:  # Press ctrl-c to end the program.
        print("Ending program")

