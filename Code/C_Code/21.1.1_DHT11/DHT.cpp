/**********************************************************************
* Filename    : DHT.cpp
* Description : DHT Temperature & Humidity Sensor library for Raspberry
* Author      : freenove
* modification: 2016/07/10
**********************************************************************/
#include "DHT.hpp"
//Function: Read DHT sensor, store the original data in bits[]
// return values:DHTLIB_OK   DHTLIB_ERROR_CHECKSUM  DHTLIB_ERROR_TIMEOUT
int DHT::readSensor(int pin,int wakeupDelay){
	int mask = 0x80;
	int idx = 0;
	int i ;
	int32_t t;
	for (i=0;i<5;i++){
		bits[i] = 0;
	}
	pinMode(pin,OUTPUT);
	digitalWrite(pin,LOW);
	delay(wakeupDelay);
	digitalWrite(pin,HIGH);
	delayMicroseconds(40);
	pinMode(pin,INPUT);
	
	int loopCnt = DHTLIB_TIMEOUT;
	t = micros();
	while(digitalRead(pin)==LOW){
		if((micros() - t) > loopCnt){
			return DHTLIB_ERROR_TIMEOUT;
		}
	}
	loopCnt = DHTLIB_TIMEOUT;
	t = micros();
	while(digitalRead(pin)==HIGH){
		if((micros() - t) > loopCnt){
			return DHTLIB_ERROR_TIMEOUT;
		}
	}
	for (i = 0; i<40;i++){
		loopCnt = DHTLIB_TIMEOUT;
		t = micros();
		while(digitalRead(pin)==LOW){
			if((micros() - t) > loopCnt)
				return DHTLIB_ERROR_TIMEOUT;
		}
		t = micros();
		loopCnt = DHTLIB_TIMEOUT;
		while(digitalRead(pin)==HIGH){
			if((micros() - t) > loopCnt){
				return DHTLIB_ERROR_TIMEOUT;
			}
		}
		if((micros() - t ) > 60){
			bits[idx] |= mask;
		}
		mask >>= 1;
		if(mask == 0){
			mask = 0x80;
			idx++;
		}
	}
	pinMode(pin,OUTPUT);
	digitalWrite(pin,HIGH);
	return DHTLIB_OK;
}
//Function：Read DHT sensor, analyze the data of temperature and humidity
//return：DHTLIB_OK   DHTLIB_ERROR_CHECKSUM  DHTLIB_ERROR_TIMEOUT
int DHT::readDHT11(int pin){
	int rv ; 
	int8_t sum;
	rv = readSensor(pin,DHTLIB_DHT11_WAKEUP);
	if(rv != DHTLIB_OK){
		humidity = DHTLIB_INVALID_VALUE;
		temperature = DHTLIB_INVALID_VALUE;
		return rv;
	}
	humidity = bits[0];
	temperature = bits[2];
	sum = bits[0] + bits[2];
	if(bits[4] != sum)
		return DHTLIB_ERROR_CHECKSUM;
	return DHTLIB_OK;
}



