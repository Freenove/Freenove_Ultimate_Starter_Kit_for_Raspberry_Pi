/**********************************************************************
* Filename    : LightWater02.c
* Description : Control LED by 74HC595
* Author      : freenove
* modification: 2016/06/21
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#include <wiringShift.h>

#define   dataPin   0   //DS Pin of 74HC595(Pin14)
#define   latchPin  2   //ST_CP Pin of 74HC595(Pin12)
#define   clockPin 3    //CH_CP Pin of 74HC595(Pin11)

int main(void)
{
	int i;
	unsigned char x;
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	pinMode(dataPin,OUTPUT);
	pinMode(latchPin,OUTPUT);
	pinMode(clockPin,OUTPUT);
	while(1){
		x=0x01;
		for(i=0;i<8;i++){
			digitalWrite(latchPin,LOW);		// Output low level to latchPin
			shiftOut(dataPin,clockPin,LSBFIRST,x);// Send serial data to 74HC595
			digitalWrite(latchPin,HIGH); // Output high level to latchPin, and 74HC595 will update the data to the parallel output port.
			x<<=1; // make the variable move one bit to left once, then the bright LED move one step to the left once.
			delay(100);
		}
		x=0x80;
		for(i=0;i<8;i++){
			digitalWrite(latchPin,LOW);
			shiftOut(dataPin,clockPin,LSBFIRST,x);
			digitalWrite(latchPin,HIGH);
			x>>=1;
			delay(100);
		}
	}
	return 0;
}

