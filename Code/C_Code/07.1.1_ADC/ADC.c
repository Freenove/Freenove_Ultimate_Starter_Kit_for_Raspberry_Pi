/**********************************************************************
* Filename    : ADC.c
* Description : ADC and DAC
* Author      : freenove
* modification: 2018/09/15
**********************************************************************/

#include <wiringPi.h>
#include <pcf8591.h>
#include <stdio.h>

#define address 0x48  		//pcf8591 default address
#define pinbase 64			//any number above 64
#define A0 pinbase + 0
#define A1 pinbase + 1
#define A2 pinbase + 2
#define A3 pinbase + 3

int main(void){
	int value;
	float voltage;
	wiringPiSetup();
	pcf8591Setup(pinbase,address);
	
	while(1){
		value = analogRead(A0);  //read A0 pin
		analogWrite(pinbase+0,value);
		voltage = (float)value / 255.0 * 3.3;  // calculate voltage
		printf("ADC value : %d  ,\tVoltage : %.2fV\n",value,voltage);
		delay(100);
	}
}
