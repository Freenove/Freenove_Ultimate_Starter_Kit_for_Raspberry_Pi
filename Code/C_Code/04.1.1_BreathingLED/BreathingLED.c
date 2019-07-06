/**********************************************************************
* Filename    : BreathingLED.c
* Description : A breathing LED
* Author      : freenove
* modification: 2019/07/05
**********************************************************************/

#include <wiringPi.h>
#include <stdio.h>
#include <softPwm.h>

#define ledPin    1 //Only GPIO18 can output PWM

int main(void)
{
	int i;

	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	
	softPwmCreate(ledPin,  0, 100);//Creat SoftPWM pin

	while(1){
		for(i=0;i<100;i++){
			softPwmWrite(ledPin, i);
			delay(20);
		}
		delay(300);
		for(i=100;i>=0;i--){
			softPwmWrite(ledPin, i);
			delay(20);
		}
		delay(300);
	}
	return 0;
}

