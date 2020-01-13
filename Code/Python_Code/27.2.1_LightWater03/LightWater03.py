#!/usr/bin/env python3
#############################################################################
# Filename    : LightWater03.py
# Description : Control LED with 74HC595 on the DIY circuit board
# auther      : www.freenove.com
# modification: 2019/12/28
########################################################################
import RPi.GPIO as GPIO
import time

LSBFIRST = 1
MSBFIRST = 2

# define the pins connect to 74HC595
dataPin   = 11      # DS Pin of 74HC595(Pin14)
latchPin  = 13      # ST_CP Pin of 74HC595(Pin12)
clockPin = 15       # SH_CP Pin of 74HC595(Pin11)

# Define an array to store the pulse width of LED
pluseWidth = [0,0,0,0,0,0,0,0,64,32,16,8,4,2,1,0,0,0,0,0,0,0,0]

def setup():
    GPIO.setmode(GPIO.BOARD)        # use PHYSICAL GPIO Numbering
    GPIO.setup(dataPin, GPIO.OUT)   # set dataPin to OUTPUT mode
    GPIO.setup(latchPin, GPIO.OUT)  # set latchPin to OUTPUT mode
    GPIO.setup(clockPin, GPIO.OUT)  # set clockPin to OUTPUT mode
    
def shiftOut(dPin,cPin,order,val):
    for i in range(0,8):
        GPIO.output(cPin,GPIO.LOW);
        if(order == LSBFIRST):
            GPIO.output(dPin,(0x01&(val>>i)==0x01) and GPIO.HIGH or GPIO.LOW)
        elif(order == MSBFIRST):
            GPIO.output(dPin,(0x80&(val<<i)==0x80) and GPIO.HIGH or GPIO.LOW)
        GPIO.output(cPin,GPIO.HIGH);
        
def outData(data):
    GPIO.output(latchPin,GPIO.LOW)
    shiftOut(dataPin,clockPin,LSBFIRST,data)
    GPIO.output(latchPin,GPIO.HIGH)
    
def loop():
    moveSpeed = 0.1 # moveSpeed works like a relay, the larger, the slower
    index = 0       # array index starts from 0
    lastMove = time.time()      # record the start time
    while True:
        if(time.time() - lastMove > moveSpeed): # control speed 
            lastMove = time.time()      # Record the time point of the move
            index +=1           # move to next 
            if(index > 15):     # index to 0
                index = 0
            
        for i in range(0,64):   # The cycle of PWM is 64 cycles
            data = 0            
            for j in range(0,8):    #Calculate the output state of this loop
                if(i < pluseWidth[j+index]):    #Calculate the LED state according to the pulse width 
                    data |= 1<<j    # Calculate the data
            outData(data)           # Send the data to 74HC595

def destroy(): 
    GPIO.cleanup()

if __name__ == '__main__': # Program entrance
    print ('Program is starting...')
    setup() 
    try:
        loop()  
    except KeyboardInterrupt:   # Press ctrl-c to end the program.
        destroy()  
