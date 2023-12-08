/**********************************************************************
* Filename    : Blink.c
* Description : Basic usage of GPIO. Let led blink.
* auther      : www.freenove.com
* modification: 2019/12/26
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#define  ledPin    0	//define the led pin number

// Signal handler function
// Handle interrupt, set LED to LOW
void handle_interrupt(int signal) {
    printf("Interrupt signal caught. Exiting...\n");

    digitalWrite(ledPin, LOW);
    
    exit(0);
}

void main(void)
{	
	printf("Program is starting ... \n");
	
	wiringPiSetup();	//Initialize wiringPi.

	signal(SIGINT, handle_interrupt);

	pinMode(ledPin, OUTPUT);//Set the pin mode
	printf("Using pin%d\n",ledPin);	//Output information on terminal
	while(1){
		digitalWrite(ledPin, HIGH);  //Make GPIO output HIGH level
		printf("led turned on >>>\n");		//Output information on terminal
		delay(1000);						//Wait for 1 second
		digitalWrite(ledPin, LOW);  //Make GPIO output LOW level
		printf("led turned off <<<\n");		//Output information on terminal
		delay(1000);						//Wait for 1 second
	}
}

