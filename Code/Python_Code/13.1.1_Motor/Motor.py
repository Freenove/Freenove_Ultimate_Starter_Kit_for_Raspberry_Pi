#!/usr/bin/env python3
#############################################################################
# Filename    : Motor.py
# Description : Control Motor with L293D
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
import RPi.GPIO as GPIO
import time
from ADCDevice import *

# define the pins connected to L293D 
motoRPin1 = 13
motoRPin2 = 11
enablePin = 15
adc = ADCDevice() # Define an ADCDevice class object

def setup():
    global adc
    if(adc.detectI2C(0x48)): # Detect the pcf8591.
        adc = PCF8591()
    elif(adc.detectI2C(0x4b)): # Detect the ads7830
        adc = ADS7830()
    else:
        print("No correct I2C address found, \n"
        "Please use command 'i2cdetect -y 1' to check the I2C address! \n"
        "Program Exit. \n");
        exit(-1)
    global p
    GPIO.setmode(GPIO.BOARD)   
    GPIO.setup(motoRPin1,GPIO.OUT)   # set pins to OUTPUT mode
    GPIO.setup(motoRPin2,GPIO.OUT)
    GPIO.setup(enablePin,GPIO.OUT)
        
    p = GPIO.PWM(enablePin,1000) # creat PWM and set Frequence to 1KHz
    p.start(0)

# mapNUM function: map the value from a range of mapping to another range.
def mapNUM(value,fromLow,fromHigh,toLow,toHigh):
    return (toHigh-toLow)*(value-fromLow) / (fromHigh-fromLow) + toLow
	
# motor function: determine the direction and speed of the motor according to the input ADC value input
def motor(ADC):
    value = ADC -128
    if (value > 0):  # make motor turn forward
        GPIO.output(motoRPin1,GPIO.HIGH)  # motoRPin1 output HIHG level
        GPIO.output(motoRPin2,GPIO.LOW)   # motoRPin2 output LOW level
        print ('Turn Forward...')
    elif (value < 0): # make motor turn backward
        GPIO.output(motoRPin1,GPIO.LOW)
        GPIO.output(motoRPin2,GPIO.HIGH)
        print ('Turn Backward...')
    else :
        GPIO.output(motoRPin1,GPIO.LOW)
        GPIO.output(motoRPin2,GPIO.LOW)
        print ('Motor Stop...')
    p.start(mapNUM(abs(value),0,128,0,100))
    print ('The PWM duty cycle is %d%%\n'%(abs(value)*100/127))   # print PMW duty cycle.

def loop():
    while True:
        value = adc.analogRead(0) # read ADC value of channel 0
        print ('ADC Value : %d'%(value))
        motor(value)
        time.sleep(0.01)

def destroy():
    GPIO.cleanup()
    
if __name__ == '__main__':  # Program entrance
    print ('Program is starting ... ')
    setup()
    try:
        loop()
    except KeyboardInterrupt: # Press ctrl-c to end the program.
        destroy()

