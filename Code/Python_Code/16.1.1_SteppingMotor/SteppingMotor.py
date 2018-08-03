#!/usr/bin/env python3
########################################################################
# Filename    : SteppingMotor.py
# Description : 
# Author      : freenove
# modification: 2018/08/02
########################################################################
import RPi.GPIO as GPIO
import time 

motorPins = (12, 16, 18, 22)    #define pins connected to four phase ABCD of stepper motor
CCWStep = (0x01,0x02,0x04,0x08) #define power supply order for coil for rotating anticlockwise 
CWStep = (0x08,0x04,0x02,0x01)  #define power supply order for coil for rotating clockwise

def setup():
    print ('Program is starting...')
    GPIO.setmode(GPIO.BOARD)       # Numbers GPIOs by physical location
    for pin in motorPins:
        GPIO.setup(pin,GPIO.OUT)
#as for four phase stepping motor, four steps is a cycle. the function is used to drive the stepping motor clockwise or anticlockwise to take four steps    
def moveOnePeriod(direction,ms):    
    for j in range(0,4,1):      #cycle for power supply order
        for i in range(0,4,1):  #assign to each pin, a total of 4 pins
            if (direction == 1):#power supply order clockwise
                GPIO.output(motorPins[i],((CCWStep[j] == 1<<i) and GPIO.HIGH or GPIO.LOW))
            else :              #power supply order anticlockwise
                GPIO.output(motorPins[i],((CWStep[j] == 1<<i) and GPIO.HIGH or GPIO.LOW))
        if(ms<3):       #the delay can not be less than 3ms, otherwise it will exceed speed limit of the motor
            ms = 3
        time.sleep(ms*0.001)    
#continuous rotation function, the parameter steps specifies the rotation cycles, every four steps is a cycle
def moveSteps(direction, ms, steps):
    for i in range(steps):
        moveOnePeriod(direction, ms)
#function used to stop rotating
def motorStop():
    for i in range(0,4,1):
        GPIO.output(motorPins[i],GPIO.LOW)
            
def loop():
    while True:
        moveSteps(1,3,512)  #rotating   360 deg clockwise, a total of 2048 steps in a circle, namely, 512 cycles.
        time.sleep(0.5)
        moveSteps(0,3,512)  #rotating 360 deg anticlockwise
        time.sleep(0.5)

def destroy():
    GPIO.cleanup()             # Release resource

if __name__ == '__main__':     # Program start from here
    setup()
    try:
        loop()
    except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.
        destroy()


