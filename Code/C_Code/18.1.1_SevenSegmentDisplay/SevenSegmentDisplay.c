/**********************************************************************
* Filename    : SevenSegmentDisplay.c
* Description : Control SevenSegmentDisplay by 74HC595
* Author      : freenove
* modification: 2016/06/24
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#include <wiringShift.h>

#define   dataPin   0   //DS Pin of 74HC595(Pin14)
#define   latchPin  2   //ST_CP Pin of 74HC595(Pin12)
#define   clockPin 3    //CH_CP Pin of 74HC595(Pin11)
//encoding for character 0-F of common anode SevenSegmentDisplay. 
unsigned char num[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,0x88,0x83,0xc6,0xa1,0x86,0x8e};

int main(void)
{
	int i;
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	pinMode(dataPin,OUTPUT);
	pinMode(latchPin,OUTPUT);
	pinMode(clockPin,OUTPUT);
	while(1){
		for(i=0;i<sizeof(num);i++){
			digitalWrite(latchPin,LOW);
			shiftOut(dataPin,clockPin,MSBFIRST,num[i]);//Output the figures and the highest level is transfered preferentially. 
			digitalWrite(latchPin,HIGH);
			delay(500);
		}
		for(i=0;i<sizeof(num);i++){
			digitalWrite(latchPin,LOW);
			shiftOut(dataPin,clockPin,MSBFIRST,num[i] & 0x7f);//Use the "&0x7f" to display the decimal point.
			digitalWrite(latchPin,HIGH);
			delay(500);
		}
	}
	return 0;
}

