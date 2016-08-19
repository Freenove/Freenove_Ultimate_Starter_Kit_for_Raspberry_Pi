/**********************************************************************
* Filename    : LightWater.c
* Description : Display 10 LEDBar Graph 
* Author      : freenove
* modification: 2016/06/13
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#define leds 10
int pins[leds] = {0,1,2,3,4,5,6,8,9,10};
void led_on(int n)//make led_n on
{
	digitalWrite(n, LOW);
}

void led_off(int n)//make led_n off
{
	digitalWrite(n, HIGH);
}

int main(void)
{
	int i;
	printf("Program is starting ... \n");
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	for(i=0;i<leds;i++){       //make leds pins' mode is output
		pinMode(pins[i], OUTPUT);
	}
	while(1){
		for(i=0;i<leds;i++){   //make led on from left to right
			led_on(pins[i]);
			delay(100);
			led_off(pins[i]);
		}
		for(i=leds-1;i>-1;i--){   //make led on from right to left
			led_on(pins[i]);
			delay(100);
			led_off(pins[i]);
		}
	}
	return 0;
}

