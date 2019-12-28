/**********************************************************************
* Filename    : ADC.c
* Description : ADC and DAC
* Author      : www.freenove.com
* modification: 2019/12/27
**********************************************************************/
#include <wiringPi.h>
#include <pcf8591.h>
#include <stdio.h>

#define address 0x48  		//pcf8591 default address
#define pinbase 64			//any number above 64 (according to the wiringPi library)
#define A0 pinbase + 0
#define A1 pinbase + 1
#define A2 pinbase + 2
#define A3 pinbase + 3

int main(void){
	int value;
	float voltage;
	
	printf("Program is starting ... \n");
	
	wiringPiSetup(); //Initialize wiringPi.
	
	pcf8591Setup(pinbase,address);
	
	while(1){
		value = analogRead(A0);  //read analog value of A0 pin
		analogWrite(pinbase+0,value);
		voltage = (float)value / 255.0 * 3.3;  // Calculate voltage
		printf("ADC value : %d  ,\tVoltage : %.2fV\n",value,voltage);
		delay(100);
	}
}
