/**********************************************************************
* Filename    : ColorfulLED.c
* Description : A auto flash ColorfulLED
* Author      : freenove
* modification: 2016/06/14
**********************************************************************/
#include <wiringPi.h>
#include <softPwm.h>
#include <stdio.h>

#define ledPinRed    0
#define ledPinGreen  1
#define ledPinBlue   2

void ledInit(void)
{
	softPwmCreate(ledPinRed,  0, 100);//Creat SoftPWM pin
	softPwmCreate(ledPinGreen,0, 100);
	softPwmCreate(ledPinBlue, 0, 100);
}

void ledColorSet(int r_val, int g_val, int b_val)
{
	softPwmWrite(ledPinRed,   r_val);//Set the duty cycle 
	softPwmWrite(ledPinGreen, g_val);
	softPwmWrite(ledPinBlue,  b_val);
}

int main(void)
{
	int r,g,b;
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	printf("Program is starting ...\n");
	ledInit();

	while(1){
		r=random()%100;//get a random in (0,100)
		g=random()%100;
		b=random()%100;
		ledColorSet(r,g,b);//set random as a duty cycle value 
		printf("r=%d,  g=%d,  b=%d \n",r,g,b);
		delay(300);
	}
	return 0;
}
