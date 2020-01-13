#!/usr/bin/env python3
#############################################################################
# Filename    : ADC.py
# Description : Analog and Digital Conversion, ADC and DAC
# Author      : www.freenove.com
# modification: 2019/12/27
########################################################################
import smbus
import time

address = 0x48  # default address of PCF8591
bus=smbus.SMBus(1)
cmd=0x40        # command, 0100 0000

def analogRead(chn): # read ADC value,chn:0,1,2,3
    value = bus.read_byte_data(address,cmd+chn)
    return value
    
def analogWrite(value): # write DAC value
    bus.write_byte_data(address,cmd,value)  
    
def loop():
    while True:
        value = analogRead(0)   # read the ADC value of channel 0
        analogWrite(value)      # write the DAC value to control led
        voltage = value / 255.0 * 3.3  # calculate the voltage value
        print ('ADC Value : %d, Voltage : %.2f'%(value,voltage))
        time.sleep(0.01)

def destroy():
    bus.close()
    
if __name__ == '__main__':   # Program entrance
    print ('Program is starting ... ')
    try:
        loop()
    except KeyboardInterrupt: # Press ctrl-c to end the program.
        destroy()
        
    
