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
  
public class FlowingLight02 {  
    private static final int DATA_PIN = 22;  
    private static final int LATCH_PIN = 27;  
    private static final int CLOCK_PIN = 17;  
  
    public static void main(String[] args) throws Exception {  
        var pi4j = Pi4J.newAutoContext();  
        HC595 ledbar = new HC595(pi4j, DATA_PIN, LATCH_PIN, CLOCK_PIN);  
  
        try {  
            int x;  
            while (true) {  
                x = 0x0001;  
                for (int i = 0; i < 10; i++) {  
                    ledbar.shiftOut(HC595.Order.MSBFIRST, (x >> 8) & 0xff); // Dummy shift for higher bits  
                    ledbar.shiftOut(HC595.Order.MSBFIRST, x & 0xff);  
                    ledbar.updateLatch();  
                    x <<= 1;  
                    Thread.sleep(100);  
                }  
  
                x = 0x0200;  
                for (int i = 0; i < 10; i++) {  
                    ledbar.shiftOut(HC595.Order.MSBFIRST, (x >> 8) & 0xff); // Dummy shift for higher bits  
                    ledbar.shiftOut(HC595.Order.MSBFIRST, x & 0xff);   
                    ledbar.updateLatch();  
                    x >>= 1;  
                    Thread.sleep(100);  
                }  
            }  
        } finally {  
            ledbar.shutdown();  
        }  
    }  
}