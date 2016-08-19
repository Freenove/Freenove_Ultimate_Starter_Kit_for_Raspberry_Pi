/**********************************************************************
* Filename    : BreathingLED.c
* Description : A breathing LED
* Author      : freenove
* modification: 2016/06/14
**********************************************************************/

#include <wiringPi.h>
#include <stdio.h>

#define ledPin    1 //Only GPIO18 can output PWM

int main(void)
{
	int i;

	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	
	pinMode(ledPin, PWM_OUTPUT);//pwm output mode

	while(1){
		for(i=0;i<1024;i++){
			pwmWrite(ledPin, i);
			delay(2);
		}
		delay(300);
		for(i=1023;i>=0;i--){
			pwmWrite(ledPin, i);
			delay(2);
		}
		delay(300);
	}
	return 0;
}

