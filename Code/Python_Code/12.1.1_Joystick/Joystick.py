#!/usr/bin/env python3
#############################################################################
# Filename    : Joystick.py
# Description : Read Joystick state
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
import RPi.GPIO as GPIO
import smbus
import time

address = 0x48
bus=smbus.SMBus(1)
cmd=0x40
Z_Pin = 12      # define Z_Pin
def analogRead(chn):        # read ADC value
    bus.write_byte(address,cmd+chn)
    value = bus.read_byte(address)
    value = bus.read_byte(address)
    # value = bus.read_byte_data(address,cmd+chn)
    return value
    
def analogWrite(value):
    bus.write_byte_data(address,cmd,value)  

def setup():
    GPIO.setmode(GPIO.BOARD)        
    GPIO.setup(Z_Pin,GPIO.IN,GPIO.PUD_UP)   # set Z_Pin to pull-up mode
def loop():
    while True:     
        val_Z = GPIO.input(Z_Pin)       # read digital value of axis Z
        val_Y = analogRead(0)           # read analog value of axis X and Y
        val_X = analogRead(1)
        print ('value_X: %d ,\tvlue_Y: %d ,\tvalue_Z: %d'%(val_X,val_Y,val_Z))
        time.sleep(0.01)

def destroy():
    bus.close()
    GPIO.cleanup()
    
if __name__ == '__main__':
    print ('Program is starting ... ') # Program entrance
    setup()
    try:
        loop()
    except KeyboardInterrupt: # Press ctrl-c to end the program.
        destroy()
