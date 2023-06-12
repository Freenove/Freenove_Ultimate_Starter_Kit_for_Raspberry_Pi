#!/usr/bin/env python3
#############################################################################
# Filename    : LightWater03.py
# Description : Control LED with 74HC595 on the DIY circuit board
# auther      : www.freenove.com
# modification: 2023/05/15
########################################################################
from gpiozero import OutputDevice
import time

LSBFIRST = 1
MSBFIRST = 2

# define the pins for 74HC595
dataPin   = OutputDevice(17)      # DS Pin of 74HC595(Pin14)
latchPin  = OutputDevice(27)      # ST_CP Pin of 74HC595(Pin12)
clockPin  = OutputDevice(22)      # CH_CP Pin of 74HC595(Pin11)

# Define an array to store the pulse width of LED
pluseWidth = [0,0,0,0,0,0,0,0,64,32,16,8,4,2,1,0,0,0,0,0,0,0,0]
  
# shiftOut function, use bit serial transmission. 
def shiftOut(order,val):      
    for i in range(0,8):
        clockPin.off()
        if(order == LSBFIRST):
            dataPin.on() if (0x01&(val>>i)==0x01) else dataPin.off()
        elif(order == MSBFIRST):
            dataPin.on() if (0x80&(val<<i)==0x80) else dataPin.off()
        clockPin.on()
        
def outData(data):
    latchPin.off()
    shiftOut(LSBFIRST,data)
    latchPin.on()
    
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
    dataPin.close()
    latchPin.close()
    clockPin.close() 

if __name__ == '__main__': # Program entrance
    print ('Program is starting...')
    try:
        loop()  
    except KeyboardInterrupt:   # Press ctrl-c to end the program.
        destroy()
        print("Ending program")
