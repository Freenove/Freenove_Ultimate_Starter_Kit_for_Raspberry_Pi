/**********************************************************************
* Filename    : Alertor.c
* Description : Alarm by button.
* Author      : freenove
* modification: 2016/06/14
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#include <softTone.h>
#include <math.h>

#define buzzerPin    0  	//define the buzzerPin
#define buttonPin 	 1		//define the buttonPin

void alertor(int pin){
	int x;
	double sinVal, toneVal;
	for(x=0;x<360;x++){ //frequency of the alarm along the sine wave change
		sinVal = sin(x * (M_PI / 180));		//calculate the sine value
		toneVal = 2000 + sinVal * 500;		//Add to the resonant frequency with a Weighted
		softToneWrite(pin,toneVal);			//output PWM
		delay(1);
	}
}
void stopAlertor(int pin){
	softToneWrite(pin,0);
}
int main(void)
{
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}	
	pinMode(buzzerPin, OUTPUT); 
	pinMode(buttonPin, INPUT);
	softToneCreate(buzzerPin);
	pullUpDnControl(buttonPin, PUD_UP);  //pull up to high level
	while(1){	
		if(digitalRead(buttonPin) == LOW){ //button has pressed down
			alertor(buzzerPin);   //buzzer on
			printf("alertor on...\n");
		}
		else {				//button has released 
			stopAlertor(buzzerPin);   //buzzer off
			printf("...buzzer off\n");
		}
	}
	return 0;
}

