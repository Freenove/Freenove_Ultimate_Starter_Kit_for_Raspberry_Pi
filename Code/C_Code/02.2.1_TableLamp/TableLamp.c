/**********************************************************************
* Filename    : Tablelamp.c
* Description : a DIY MINI table lamp
* Author      : freenove
* modification: 2016/06/13
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>

#define ledPin    0  	//define the ledPin
#define buttonPin 1		//define the buttonPin
int ledState=LOW;		//store the State of led
int buttonState=HIGH;	//store the State of button
int lastbuttonState=HIGH;//store the lastState of button
long lastChangeTime;	//store the change time of button state
long captureTime=50;	//set the button state stable time
int reading;
int main(void)
{
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	printf("Program is starting...\n");
	pinMode(ledPin, OUTPUT); 
	pinMode(buttonPin, INPUT);

	pullUpDnControl(buttonPin, PUD_UP);  //pull up to high level
	while(1){
		reading = digitalRead(buttonPin); //read the current state of button
		if( reading != lastbuttonState){  //if the button state has changed ,record the time point
			lastChangeTime = millis();
		}
		//if changing-state of the button last beyond the time we set,we considered that 
		//the current button state is an effective change rather than a buffeting
		if(millis() - lastChangeTime > captureTime){
			//if button state is changed ,update the data.
			if(reading != buttonState){
				buttonState = reading;
				//if the state is low ,the action is pressing
				if(buttonState == LOW){
					printf("Button is pressed!\n");
					ledState = !ledState; //Turn the LED state .
					if(ledState){
						printf("turn on LED ...\n");
					}
					else {
						printf("turn off LED ...\n");
					}
				}
				//if the state is high ,the action is releasing
				else {
					printf("Button is released!\n");
				}
			}
		}
		digitalWrite(ledPin,ledState);
		lastbuttonState = reading;
	}

	return 0;
}

