/**********************************************************************
* Filename    : ColorfulSoftlight.c
* Description : Potentiometer control RGBLED
* Author      : freenove
* modification: 2016/07/03
**********************************************************************/
#include <wiringPi.h>
#include <pcf8591.h>
#include <stdio.h>
#include <softPwm.h>

#define address 0x48        //pcf8591 default address
#define pinbase 64          //any number above 64
#define A0 pinbase + 0
#define A1 pinbase + 1
#define A2 pinbase + 2
#define A3 pinbase + 3

#define ledRedPin 3         //define 3 pins of RGBLED
#define ledGreenPin 2
#define ledBluePin 0
int main(void){
    int val_Red,val_Green,val_Blue;
    if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
        printf("setup wiringPi failed !");
        return 1; 
    }
    softPwmCreate(ledRedPin,0,100);     //creat 3 PMW output pins for RGBLED
    softPwmCreate(ledGreenPin,0,100);
    softPwmCreate(ledBluePin,0,100);
    pcf8591Setup(pinbase,address);      //initialize PCF8591
    
    while(1){
        val_Red = analogRead(A0);  //read 3 potentiometers
        val_Green = analogRead(A1);
        val_Blue = analogRead(A2);
        softPwmWrite(ledRedPin,val_Red*100/255);    //map the read value of potentiometers into PWM value and output it
        softPwmWrite(ledGreenPin,val_Green*100/255);
        softPwmWrite(ledBluePin,val_Blue*100/255);
        //print out the read ADC value
        printf("ADC value val_Red: %d  ,\tval_Green: %d  ,\tval_Blue: %d \n",val_Red,val_Green,val_Blue);
        delay(100);
    }
    return 0;
}
