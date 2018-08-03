#!/usr/bin/env python3
#############################################################################
# Filename    : Motor.py
# Description : Control Motor by L293D
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import smbus
import time

address = 0x48
bus=smbus.SMBus(1)
cmd=0x40
# define the pin connected to L293D 
motoRPin1 = 13
motoRPin2 = 11
enablePin = 15

def analogRead(chn):
    value = bus.read_byte_data(address,cmd+chn)
    return value
    
def analogWrite(value):
    bus.write_byte_data(address,cmd,value)  

def setup():
    global p
    GPIO.setmode(GPIO.BOARD)    # set mode for pin
    GPIO.setup(motoRPin1,GPIO.OUT)
    GPIO.setup(motoRPin2,GPIO.OUT)
    GPIO.setup(enablePin,GPIO.OUT)
        
    p = GPIO.PWM(enablePin,1000)# creat PWM
    p.start(0)
#mapNUM function: map the value from a range of mapping to another range.

def mapNUM(value,fromLow,fromHigh,toLow,toHigh):
    return (toHigh-toLow)*(value-fromLow) / (fromHigh-fromLow) + toLow
#motor function: determine the direction and speed of the motor according to the ADC value to be input.
def motor(ADC):
    value = ADC -128
    if (value > 0):
        GPIO.output(motoRPin1,GPIO.HIGH)
        GPIO.output(motoRPin2,GPIO.LOW)
        print ('Turn Forward...')
    elif (value < 0):
        GPIO.output(motoRPin1,GPIO.LOW)
        GPIO.output(motoRPin2,GPIO.HIGH)
        print ('Turn Backward...')
    else :
        GPIO.output(motoRPin1,GPIO.LOW)
        GPIO.output(motoRPin2,GPIO.LOW)
        print ('Motor Stop...')
    p.start(mapNUM(abs(value),0,128,0,100))
    print ('The PWM duty cycle is %d%%\n'%(abs(value)*100/127))   #print PMW duty cycle.

def loop():
    while True:
        value = analogRead(0)
        print ('ADC Value : %d'%(value))
        motor(value)
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

