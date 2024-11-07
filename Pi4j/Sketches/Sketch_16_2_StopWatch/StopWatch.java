///usr/bin/env jbang "$0" "$@" ; exit $?  
  
//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  
  
import com.pi4j.Pi4J;  
import com.pi4j.context.Context;  
import com.pi4j.io.gpio.digital.DigitalOutput;  
  
class HC595 {  
    public enum Order {LSBFIRST, MSBFIRST};  
    private final DigitalOutput dataPin;  
    private final DigitalOutput latchPin;  
    private final DigitalOutput clockPin;  
    private final Context pi4j;  
 
    public HC595(Context pi4j, int dataPin, int latchPin, int clockPin) {  
        this.pi4j = pi4j;  
        this.dataPin = pi4j.dout().create(dataPin);  
        this.latchPin = pi4j.dout().create(latchPin);  
        this.clockPin = pi4j.dout().create(clockPin);  
    }  
    
    private static void delayUs(long us) {  
        long startTime = System.nanoTime();  
        long endTime = startTime + (us * 1000);  
        while (System.nanoTime() < endTime) {  
        }  
    }  
  
    public void shiftOut(Order order, int val) {  
        int i;  
        for (i = 0; i < 8; i++) {  
            clockPin.low();  
            if (order == Order.LSBFIRST) {  
                if ((0x01 & (val >> i)) == 0x01) {  
                    dataPin.high();  
                } else {  
                    dataPin.low();  
                }  
            } else {  
                if ((0x80 & (val << i)) == 0x80) {  
                    dataPin.high();  
                } else {  
                    dataPin.low();  
                }  
            }  
            clockPin.high();  
        }  
    }  

    public void updateLatch() {  
        latchPin.low();  
        delayUs(1);  
        latchPin.high();  
    }  
  
    public void shutdown() {  
        pi4j.shutdown();  
    }  
}  
  
public class StopWatch {  
    private static final int DATA_PIN = 22;  
    private static final int LATCH_PIN = 27;  
    private static final int CLOCK_PIN = 17;  
	private static final int[] values = {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90, 0x88, 0x83, 0xc6, 0xa1, 0x86, 0x8e};  
	private static final int[] bits   = {0x01, 0x02, 0x04, 0x08};
	
	public static void display(HC595 segment, int dec, int times){
		int thousand_bit = (int)dec%10000/1000;
		int hundred_bit  = (int)dec%1000/100;
		int ten_bit      = (int)dec%100/10;
		int units_bit    = (int)dec%10;
		
		try {  
			for(int i=0; i<times; i++){
				segment.shiftOut(HC595.Order.MSBFIRST, bits[0] & 0xff);  
				segment.shiftOut(HC595.Order.MSBFIRST, values[thousand_bit] & 0xff);  
				segment.updateLatch(); 
				Thread.sleep(1); 

				segment.shiftOut(HC595.Order.MSBFIRST, bits[1] & 0xff);  
				segment.shiftOut(HC595.Order.MSBFIRST, values[hundred_bit] & 0xff);  
				segment.updateLatch(); 
				Thread.sleep(1); 

				segment.shiftOut(HC595.Order.MSBFIRST, bits[2] & 0xff);  
				segment.shiftOut(HC595.Order.MSBFIRST, values[ten_bit] & 0xff);  
				segment.updateLatch(); 
				Thread.sleep(1); 

				segment.shiftOut(HC595.Order.MSBFIRST, bits[3] & 0xff);  
				segment.shiftOut(HC595.Order.MSBFIRST, values[units_bit] & 0xff);  
				segment.updateLatch(); 
				Thread.sleep(1); 
			}
		} catch (InterruptedException e) {  
			Thread.currentThread().interrupt(); 
		}  
	}
	
    public static void main(String[] args) throws Exception {  
        var pi4j = Pi4J.newAutoContext();  
        HC595 segment = new HC595(pi4j, DATA_PIN, LATCH_PIN, CLOCK_PIN);  
  
        try {  
            while (true) {  
                for (int i=0; i<9999; i++) {  
					display(segment, i, 100);
                }  
            }  
        } finally {  
            segment.shutdown();  
        }  
    }  
}
