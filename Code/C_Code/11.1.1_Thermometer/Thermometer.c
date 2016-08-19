/**********************************************************************
* Filename    : Thermometer.c
* Description : A DIY Thermometer
* Author      : freenove
* modification: 2016/06/20
**********************************************************************/
#include <wiringPi.h>
#include <pcf8591.h>
#include <stdio.h>
#include <math.h>

#define address 0x48  		//pcf8591 default address
#define pinbase 64			//any number above 64
#define A0 pinbase + 0
#define A1 pinbase + 1
#define A2 pinbase + 2
#define A3 pinbase + 3

int main(void){
	int adcValue;
	float tempK,tempC;
	float voltage,Rt;
	if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
		printf("setup wiringPi failed !");
		return 1; 
	}
	pcf8591Setup(pinbase,address);
	while(1){
		adcValue = analogRead(A0);  //read A0 pin	
		voltage = (float)adcValue / 255.0 * 3.3;	// calculate voltage	
		Rt = 10 * voltage / (3.3 - voltage);		//calculate resistance value of thermistor
		tempK = 1/(1/(273.15 + 25) + log(Rt/10)/3950.0); //calculate temperature (Kelvin)
		tempC = tempK -273.15;		//calculate temperature (Celsius)
		printf("ADC value : %d  ,\tVoltage : %.2fV, \tTemperature : %.2fC\n",adcValue,voltage,tempC);
		delay(100);
	}
	return 0;
}
