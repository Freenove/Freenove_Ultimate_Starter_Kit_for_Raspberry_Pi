/**********************************************************************
* Filename    : Nightlamp.c
* Description : Photoresistor control LED
* Author      : freenove
* modification: 2016/06/18
**********************************************************************/
#include <wiringPi.h>
#include <pcf8591.h>
#include <stdio.h>
#include <softPwm.h>

#define address 0x48  		//pcf8591 default address
#define pinbase 64			//any number above 64
#define A0 pinbase + 0
#define A1 pinbase + 1
#define A2 pinbase + 2
#define A3 pinbase + 3

#define ledPin 0
int main(void){
	int value;
	float voltage;
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	softPwmCreate(ledPin,0,100);
	pcf8591Setup(pinbase,address);
	
	while(1){
		value = analogRead(A0);  //read A0 pin
		softPwmWrite(ledPin,value*100/255);
		voltage = (float)value / 255.0 * 3.3;  // calculate voltage
		printf("ADC value : %d  ,\tVoltage : %.2fV\n",value,voltage);
		delay(100);
	}
	return 0;
}
