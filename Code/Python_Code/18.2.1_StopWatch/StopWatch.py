#!/usr/bin/env python3
#############################################################################
# Filename    : StopWatch.py
# Description : Control 4_Digit_7_Segment_Display with 74HC595
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
import RPi.GPIO as GPIO
import time
import threading

LSBFIRST = 1
MSBFIRST = 2
# define the pins connect to 74HC595
dataPin   = 18      # DS Pin of 74HC595
latchPin  = 16      # ST_CP Pin of 74HC595
clockPin = 12       # SH_CP Pin of 74HC595
num = (0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90)
digitPin = (11,13,15,19)    # Define the pin of 7-segment display common end
counter = 0         # Variable counter, the number will be dislayed by 7-segment display
t = 0               # define the Timer object
def setup():
    GPIO.setmode(GPIO.BOARD)     # use PHYSICAL GPIO Numbering
    GPIO.setup(dataPin, GPIO.OUT)       # Set pin mode to OUTPUT
    GPIO.setup(latchPin, GPIO.OUT)
    GPIO.setup(clockPin, GPIO.OUT)
    for pin in digitPin:
        GPIO.setup(pin,GPIO.OUT)
    
def shiftOut(dPin,cPin,order,val):      
    for i in range(0,8):
        GPIO.output(cPin,GPIO.LOW);
        if(order == LSBFIRST):
            GPIO.output(dPin,(0x01&(val>>i)==0x01) and GPIO.HIGH or GPIO.LOW)
        elif(order == MSBFIRST):
            GPIO.output(dPin,(0x80&(val<<i)==0x80) and GPIO.HIGH or GPIO.LOW)
        GPIO.output(cPin,GPIO.HIGH)
            
def outData(data):      # function used to output data for 74HC595
    GPIO.output(latchPin,GPIO.LOW)
    shiftOut(dataPin,clockPin,MSBFIRST,data)
    GPIO.output(latchPin,GPIO.HIGH)
    
def selectDigit(digit): # Open one of the 7-segment display and close the remaining three, the parameter digit is optional for 1,2,4,8
    GPIO.output(digitPin[0],GPIO.LOW if ((digit&0x08) == 0x08) else GPIO.HIGH)
    GPIO.output(digitPin[1],GPIO.LOW if ((digit&0x04) == 0x04) else GPIO.HIGH)
    GPIO.output(digitPin[2],GPIO.LOW if ((digit&0x02) == 0x02) else GPIO.HIGH)
    GPIO.output(digitPin[3],GPIO.LOW if ((digit&0x01) == 0x01) else GPIO.HIGH)

def display(dec):   # display function for 7-segment display
    outData(0xff)   # eliminate residual display
    selectDigit(0x01)   # Select the first, and display the single digit
    outData(num[dec%10])
    time.sleep(0.003)   # display duration
    outData(0xff)
    selectDigit(0x02)   # Select the second, and display the tens digit
    outData(num[dec%100//10])
    time.sleep(0.003)
    outData(0xff)
    selectDigit(0x04)   # Select the third, and display the hundreds digit
    outData(num[dec%1000//100])
    time.sleep(0.003)
    outData(0xff)
    selectDigit(0x08)   # Select the fourth, and display the thousands digit
    outData(num[dec%10000//1000])
    time.sleep(0.003)
def timer():       
    global counter
    global t
    t = threading.Timer(1.0,timer)      # reset time of timer to 1s
    t.start()                           # Start timing
    counter+=1                          
    print ("counter : %d"%counter)
    
def loop():
    global t
    global counter
    t = threading.Timer(1.0,timer)      # set the timer
    t.start()                           # Start timing
    while True:
        display(counter)                # display the number counter
        
def destroy():  
    global t
    GPIO.cleanup()      
    t.cancel()     

if __name__ == '__main__': # Program entrance
    print ('Program is starting...' )
    setup() 
    try:
        loop()  
    except KeyboardInterrupt:   # Press ctrl-c to end the program.
        destroy()  
 
