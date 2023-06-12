#!/usr/bin/env python3
########################################################################
# Filename    : LightWater.py
# Description : Use LEDBar Graph(10 LED) 
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
from gpiozero import LEDBoard
from time import sleep
from signal import pause

print ('Program is starting ... ')

ledPins = ["J8:11", "J8:12","J8:13","J8:15","J8:16","J8:18","J8:22","J8:3","J8:5","J8:24"]

leds = LEDBoard(*ledPins, active_high=False)

while True:
    for index in range(0,len(ledPins),1):       #move led(on) from left to right 
        leds.on(index)  
        sleep(0.1)
        leds.off(index)
    for index in range(len(ledPins)-1,-1,-1):   #move led(on) from right to left
        leds.on(index)      
        sleep(0.1)
        leds.off(index)


