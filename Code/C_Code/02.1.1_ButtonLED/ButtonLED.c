/**********************************************************************
* Filename    : ButtonLED.c
* Description : Controlling an led by button.
* Author      : freenove
* modification: 2016/06/12
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>

#define ledPin    0  	//define the ledPin
#define buttonPin 1		//define the buttonPin

int main(void)
{
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	
	pinMode(ledPin, OUTPUT); //Set ledPin output
	pinMode(buttonPin, INPUT);//Set buttonPin input

	pullUpDnControl(buttonPin, PUD_UP);  //pull up to high level
	while(1){
		
		if(digitalRead(buttonPin) == LOW){ //button has pressed down
			digitalWrite(ledPin, HIGH);   //led on
			printf("led on...\n");
		}
		else {				//button has released 
			digitalWrite(ledPin, LOW);   //led off
			printf("...led off\n");
		}
	}

	return 0;
}

