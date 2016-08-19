/**********************************************************************
* Filename    : Motor.c
* Description : Control Motor by L293D
* Author      : freenove
* modification: 2016/06/18
**********************************************************************/
#include <wiringPi.h>
#include <pcf8591.h>
#include <stdio.h>
#include <softPwm.h>
#include <math.h>
#include <stdlib.h>

#define address 0x48  		//pcf8591 default address
#define pinbase 64			//any number above 64
#define A0 pinbase + 0
#define A1 pinbase + 1
#define A2 pinbase + 2
#define A3 pinbase + 3

#define motorPin1	2		//define the pin connected to L293D
#define motorPin2	0
#define enablePin	3
//Map function: map the value from a range of mapping to another range.
long map(long value,long fromLow,long fromHigh,long toLow,long toHigh){
	return (toHigh-toLow)*(value-fromLow) / (fromHigh-fromLow) + toLow;
}
//motor function: determine the direction and speed of the motor according to the ADC 
void motor(int ADC){
	int value = ADC -128;
	if(value>0){
		digitalWrite(motorPin1,HIGH);
		digitalWrite(motorPin2,LOW);
		printf("turn Forward...\n");
	}
	else if (value<0){
		digitalWrite(motorPin1,LOW);
		digitalWrite(motorPin2,HIGH);
		printf("turn Back...\n");
	}
	else {
		digitalWrite(motorPin1,LOW); 
		digitalWrite(motorPin2,LOW);
		printf("Motor Stop...\n");
	}
	softPwmWrite(enablePin,map(abs(value),0,128,0,255));
	printf("The PWM duty cycle is %d%%\n",abs(value)*100/127);//print the PMW duty cycle
}
int main(void){
	int value;
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	pinMode(enablePin,OUTPUT);//set mode for the pin
	pinMode(motorPin1,OUTPUT);
	pinMode(motorPin2,OUTPUT);
	softPwmCreate(enablePin,0,100);//define PMW pin
	pcf8591Setup(pinbase,address);//initialize PCF8591
	
	while(1){
		value = analogRead(A0);  //read A0 pin
		printf("ADC value : %d \n",value);
		motor(value);		//start the motor
		delay(100);
	}
	return 0;
}

