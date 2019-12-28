/**********************************************************************
* Filename    : LightWater03.c
* Description : Control LED by 74HC595 on DIY circuit board
* Author      : www.freenove.com
* modification: 2019/12/27
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#include <wiringShift.h>
#include <unistd.h>

#define   dataPin   0   //DS Pin of 74HC595(Pin14)
#define   latchPin  2   //ST_CP Pin of 74HC595(Pin12)
#define   clockPin 3    //SH_CP Pin of 74HC595(Pin11)
//Define an array to store the pulse width of LED, which will be output to the 8 LEDs in order.
const int pluseWidth[]={0,0,0,0,0,0,0,0,64,32,16,8,4,2,1,0,0,0,0,0,0,0,0};
void outData(int8_t data){
	digitalWrite(latchPin,LOW);
	shiftOut(dataPin,clockPin,LSBFIRST,data);
	digitalWrite(latchPin,HIGH);
}
int main(void)
{
	int i,j,index;	//index:current position in array pluseWidth
	int moveSpeed = 100;	//It works as a delay. The larger, the slower
	long lastMove;			//Record the last time point of the led move
	
	printf("Program is starting ...\n");
	
	wiringPiSetup();
	
	pinMode(dataPin,OUTPUT);
	pinMode(latchPin,OUTPUT);
	pinMode(clockPin,OUTPUT);
	index = 0;		//Starting from the array index 0
	lastMove = millis();	// record the start time
	while(1){
		if(millis() - lastMove > moveSpeed) { //speed control
			lastMove = millis();	//Record the time point of the move
			index++;		//move to next 
			if(index > 15) index = 0; 	//index to 0
		}
		for(i=0;i<64;i++){		//The cycle of PWM is 64 cycles
			int8_t data = 0;	 
			for(j=0;j<8;j++){	//Calculate the output state  
				if(i < pluseWidth[index+j]){	//Calculate the LED state according to the pulse width 
					data |= 0x01<<j ;	//Calculate the data
				}				
			}
			outData(data);		//Send the data to 74HC595
		}
	}
	return 0;
}

