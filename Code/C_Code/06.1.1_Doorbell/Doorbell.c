/**********************************************************************
* Filename    : Doorbell.c
* Description : Controlling an buzzer by button.
* Author      : freenove
* modification: 2016/06/12
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>

#define buzzerPin    0  	//define the buzzerPin
#define buttonPin 1		//define the buttonPin

int main(void)
{
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	
	pinMode(buzzerPin, OUTPUT); 
	pinMode(buttonPin, INPUT);

	pullUpDnControl(buttonPin, PUD_UP);  //pull up to high level
	while(1){
		
		if(digitalRead(buttonPin) == LOW){ //button has pressed down
			digitalWrite(buzzerPin, HIGH);   //buzzer on
			printf("buzzer on...\n");
		}
		else {				//button has released 
			digitalWrite(buzzerPin, LOW);   //buzzer off
			printf("...buzzer off\n");
		}
	}

	return 0;
}

