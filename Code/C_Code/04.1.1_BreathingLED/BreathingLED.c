/**********************************************************************
* Filename    : BreathingLED.c
* Description : Make breathing LED with PWM
* Author      : www.freenove.com
* modification: 2019/12/27
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#include <softPwm.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

void sigint_handler(int); //Declare signal handler function

#define ledPin    1 

void main(void)
{
	int i;
	
	printf("Program is starting ... \n");

	signal(SIGINT, sigint_handler); //Setup interrupt handler
	
	wiringPiSetup();	//Initialize wiringPi.
	
	softPwmCreate(ledPin,  0, 100);//Creat SoftPWM pin
	
	while(1){
		for(i=0;i<100;i++){  //make the led brighter
			softPwmWrite(ledPin, i); 
			delay(20);
		}
		delay(300);
		for(i=100;i>=0;i--){  //make the led darker
			softPwmWrite(ledPin, i);
			delay(20);
		}
		delay(300);
	}
}

//Set LedPin to LOW and pin mode to INPUT
void sigint_handler(int sig)
{
    printf("Killing process %d\n",getpid());
    pinMode(ledPin, INPUT);
    digitalWrite (ledPin, LOW);
    exit(0);
}


