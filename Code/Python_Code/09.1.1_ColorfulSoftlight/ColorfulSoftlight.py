#!/usr/bin/env python3
#############################################################################
# Filename    : Softlight.py
# Description : Control RGBLED with Potentiometer 
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
import RPi.GPIO as GPIO
import smbus
import time

address = 0x48
bus=smbus.SMBus(1)
cmd=0x40

ledRedPin = 15      # define 3 pins for RGBLED
ledGreenPin = 13
ledBluePin = 11

def analogRead(chn):    # read ADC value
    bus.write_byte(address,cmd+chn)
    value = bus.read_byte(address)
    value = bus.read_byte(address)
    return value
    
def analogWrite(value):
    bus.write_byte_data(address,cmd,value)  

def setup():
    global p_Red,p_Green,p_Blue
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(ledRedPin,GPIO.OUT)      # set RGBLED pins to OUTPUT mode
    GPIO.setup(ledGreenPin,GPIO.OUT)
    GPIO.setup(ledBluePin,GPIO.OUT)
    
    p_Red = GPIO.PWM(ledRedPin,1000)    # configure PMW for RGBLED pins, set PWM Frequence to 1kHz
    p_Red.start(0)
    p_Green = GPIO.PWM(ledGreenPin,1000)
    p_Green.start(0)
    p_Blue = GPIO.PWM(ledBluePin,1000)
    p_Blue.start(0)
    
def loop():
    while True:     
        value_Red = analogRead(0)       # read ADC value of 3 potentiometers
        value_Green = analogRead(1)
        value_Blue = analogRead(2)
        p_Red.ChangeDutyCycle(value_Red*100/255)  # map the read value of potentiometers into PWM value and output it 
        p_Green.ChangeDutyCycle(value_Green*100/255)
        p_Blue.ChangeDutyCycle(value_Blue*100/255)
        # print read ADC value
        print ('ADC Value value_Red: %d ,\tvlue_Green: %d ,\tvalue_Blue: %d'%(value_Red,value_Green,value_Blue))
        time.sleep(0.01)

def destroy():
    bus.close()
    GPIO.cleanup()
    
if __name__ == '__main__': # Program entrance
    print ('Program is starting ... ')
    setup()
    try:
        loop()
    except KeyboardInterrupt: # Press ctrl-c to end the program.
        destroy()
