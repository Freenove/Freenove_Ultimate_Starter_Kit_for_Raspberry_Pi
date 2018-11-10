#!/usr/bin/env python3
#############################################################################
# Filename    : Joystick.py
# Description : Read Joystick
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import smbus
import time

address = 0x48
bus=smbus.SMBus(1)
cmd=0x40
Z_Pin = 12      #define pin for Z_Pin
def analogRead(chn):        #read ADC value
    bus.write_byte(address,cmd+chn)
    value = bus.read_byte(address)
    value = bus.read_byte(address)
    #value = bus.read_byte_data(address,cmd+chn)
    return value
    
def analogWrite(value):
    bus.write_byte_data(address,cmd,value)  

def setup():
    GPIO.setmode(GPIO.BOARD)        
    GPIO.setup(Z_Pin,GPIO.IN,GPIO.PUD_UP)   #set Z_Pin to pull-up mode
def loop():
    while True:     
        val_Z = GPIO.input(Z_Pin)       #read digital quality of axis Z
        val_Y = analogRead(0)           #read analog quality of axis X and Y
        val_X = analogRead(1)
        print ('value_X: %d ,\tvlue_Y: %d ,\tvalue_Z: %d'%(val_X,val_Y,val_Z))
        time.sleep(0.01)

def destroy():
    bus.close()
    GPIO.cleanup()
    
if __name__ == '__main__':
    print ('Program is starting ... ')
    setup()
    try:
        loop()
    except KeyboardInterrupt:
        destroy()

		
	
