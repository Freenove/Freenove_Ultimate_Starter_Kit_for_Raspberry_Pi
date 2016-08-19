/**********************************************************************
* Filename    : SenseLED.c
* Description : Controlling an led by infrared Motion sensor.
* Author      : freenove
* modification: 2016/06/12
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>

#define ledPin    1  	//define the ledPin
#define sensorPin 0		//define the sensorPin

int main(void)
{
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	
	pinMode(ledPin, OUTPUT); 
	pinMode(sensorPin, INPUT);

	while(1){
		
		if(digitalRead(sensorPin) == HIGH){ //sensor has pressed down
			digitalWrite(ledPin, HIGH);   //led on
			printf("led on...\n");
		}
		else {				//sensor has released 
			digitalWrite(ledPin, LOW);   //led off
			printf("...led off\n");
		}
	}

	return 0;
}

