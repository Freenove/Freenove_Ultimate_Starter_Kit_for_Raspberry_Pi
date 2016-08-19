/**********************************************************************
* Filename    : StopWatch.c
* Description : Control 4_Digit_7_Segment_Display by 74HC595
* Author      : freenove
* modification: 2016/07/07
**********************************************************************/
#include <wiringPi.h>
#include <stdio.h>
#include <wiringShift.h>
#include <signal.h>
#include <unistd.h>
#define     dataPin     5   //DS Pin of 74HC595(Pin14)
#define     latchPin    4   //ST_CP Pin of 74HC595(Pin12)
#define     clockPin    1    //CH_CP Pin of 74HC595(Pin11)
const int digitPin[]={0,2,3,12};        // Define 7-segment display common pin
// character 0-9 code of common anode 7-segment display 
unsigned char num[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};
int counter = 0;    //variable counter,the number will be displayed by 7-segment display
//Open one of the 7-segment display and close the remaining three, the parameter digit is optional for 1,2,4,8
void selectDigit(int digit){    
    digitalWrite(digitPin[0],((digit&0x08) == 0x08) ? LOW : HIGH);
    digitalWrite(digitPin[1],((digit&0x04) == 0x04) ? LOW : HIGH);
    digitalWrite(digitPin[2],((digit&0x02) == 0x02) ? LOW : HIGH);
    digitalWrite(digitPin[3],((digit&0x01) == 0x01) ? LOW : HIGH);
}
void outData(int8_t data){      //function used to output data for 74HC595输出数据函数
    digitalWrite(latchPin,LOW);
    shiftOut(dataPin,clockPin,MSBFIRST,data);
    digitalWrite(latchPin,HIGH);
}
void display(int dec){  //display function for 7-segment display
    selectDigit(0x01);      //select the first, and display the single digit
    outData(num[dec%10]);   
    delay(1);               //display duration
    selectDigit(0x02);      //select the second, and display the tens digit
    outData(num[dec%100/10]);
    delay(1);
    selectDigit(0x04);      //select the third, and display the hundreds digit
    outData(num[dec%1000/100]);
    delay(1);
    selectDigit(0x08);      //select the fourth, and display the thousands digit
    outData(num[dec%10000/1000]);
    delay(1);
}
void timer(int  sig){       //Timer function
    if(sig == SIGALRM){   //If the signal is SIGALRM, the value of counter plus 1, and update the number displayed by 7-segment display
        counter ++;         
        alarm(1);           //set the next timer time
        printf("counter : %d \n",counter);
    }
}
int main(void)
{
    int i;
    if(wiringPiSetup() == -1){ //when initialize wiring failed,print messageto screen
        printf("setup wiringPi failed !");
        return 1; 
    }
    pinMode(dataPin,OUTPUT);        //set the pin connected to74HC595 for output mode
    pinMode(latchPin,OUTPUT);
    pinMode(clockPin,OUTPUT);
    //set the pin connected to 7-segment display common end to output mode
    for(i=0;i<4;i++){       
        pinMode(digitPin[i],OUTPUT);
        digitalWrite(digitPin[i],LOW);
    }
    signal(SIGALRM,timer);  //configure the timer
    alarm(1);               //set the time of timer to 1s
    while(1){
        display(counter);   //display the number counter
    }
    return 0;
}


