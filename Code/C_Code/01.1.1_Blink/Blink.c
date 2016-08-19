/**********************************************************************
* Filename    : Blink.c
* Description : Make an led blinking.
* auther      : www.freenove.com
* modification: 2016/06/07
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>

#define  ledPin    0

int main(void)
{
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	//when initialize wiring successfully,print message to screen	
	printf("wiringPi initialize successfully, GPIO %d(wiringPi pin)\n",ledPin); 	
	
	pinMode(ledPin, OUTPUT);//Set the pin mode

	while(1){
			digitalWrite(ledPin, HIGH);  //led on
			printf("led on...\n");
			delay(1000);
			digitalWrite(ledPin, LOW);  //led off
			printf("...led off\n");
			delay(1000);
	}

	return 0;
}

