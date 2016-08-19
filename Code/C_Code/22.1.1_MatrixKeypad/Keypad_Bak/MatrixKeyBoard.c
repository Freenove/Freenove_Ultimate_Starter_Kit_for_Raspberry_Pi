#include <wiringPi.h>
#include <stdint.h>
#include <stdio.h>
//#include "Keypad.hpp"
#define bitWrite(x,n,b)	(b ? (x |= 1<<n) : (x &= ~(1<<n)))
#define bitRead(x,n)	((((x>>n)&1) == 1) ? 1 : 0)

int main(){
	unsigned char a=0x85,b=4,c=1;
	char ch = 'A';
	printf("a : %x\n",a);
	printf("%d,%d \n",bitRead(a,7),bitRead(a,4));
	
	bitWrite(a,b,c);
	bitWrite(a,2,0);
	printf("a : %x\n",a);
	printf("%d,%d \n",bitRead(a,7),bitRead(a,4));
	
	printf("char is %c ... \n",ch);
	return 1;
}
