// Shebang line for JBang to execute this script directly  
///usr/bin/env jbang "$0" "$@" ; exit $?  
  
// Dependencies for this script  
//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  
  
import com.pi4j.Pi4J;  
import com.pi4j.context.Context;  
import com.pi4j.io.gpio.digital.DigitalOutput;  
  
/**  
 * Class to control an HC595 shift register for LED bar display.  
 */  
class HC595 {  
    /**  
     * Enumeration for data order (LSB or MSB first).  
     */  
    public enum Order {LSBFIRST, MSBFIRST};  
  
    private final DigitalOutput dataPin;  
    private final DigitalOutput latchPin;  
    private final DigitalOutput clockPin;  
    private final Context pi4j;  
  
    /**  
     * Constructor to initialize the HC595 with GPIO pins.  
     *  
     * @param pi4j Pi4J context  
     * @param dataPin GPIO pin for data  
     * @param latchPin GPIO pin for latch  
     * @param clockPin GPIO pin for clock  
     */  
    public HC595(Context pi4j, int dataPin, int latchPin, int clockPin) {  
        this.pi4j = pi4j;  
        this.dataPin = pi4j.dout().create(dataPin);  
        this.latchPin = pi4j.dout().create(latchPin);  
        this.clockPin = pi4j.dout().create(clockPin);  
    }  
  
    /**  
     * Delay in microseconds.  
     *  
     * @param us Microseconds to delay  
     */  
    private static void delayUs(long us) {  
        long startTime = System.nanoTime();  
        long endTime = startTime + (us * 1000);  
        while (System.nanoTime() < endTime) {  
        }  
    }  
  
    /**  
     * Shift data out to the HC595.  
     *  
     * @param order Data order (LSB or MSB first)  
     * @param val Data value to shift out  
     */  
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
  
    /**  
     * Update the latch pin to lock in the data.  
     */  
    public void updateLatch() {  
        latchPin.low();  
        delayUs(1);  
        latchPin.high();  
    }  
  
    /**  
     * Shutdown Pi4J context.  
     */  
    public void shutdown() {
        pi4j.shutdown();  
    }  
}  
  
public class LEDMatrix {  
    private static final int DATA_PIN = 22;  
    private static final int LATCH_PIN = 27;  
    private static final int CLOCK_PIN = 17; 
	
	private static final int[] pic  = {0x1c, 0x22, 0x51, 0x45, 0x45, 0x51, 0x22, 0x1c};
	private static final int[] data = { // data of "0-F"
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // " "
		0x00, 0x00, 0x3E, 0x41, 0x41, 0x3E, 0x00, 0x00, // "0"
		0x00, 0x00, 0x21, 0x7F, 0x01, 0x00, 0x00, 0x00, // "1"
		0x00, 0x00, 0x23, 0x45, 0x49, 0x31, 0x00, 0x00, // "2"
		0x00, 0x00, 0x22, 0x49, 0x49, 0x36, 0x00, 0x00, // "3"
		0x00, 0x00, 0x0E, 0x32, 0x7F, 0x02, 0x00, 0x00, // "4"
		0x00, 0x00, 0x79, 0x49, 0x49, 0x46, 0x00, 0x00, // "5"
		0x00, 0x00, 0x3E, 0x49, 0x49, 0x26, 0x00, 0x00, // "6"
		0x00, 0x00, 0x60, 0x47, 0x48, 0x70, 0x00, 0x00, // "7"
		0x00, 0x00, 0x36, 0x49, 0x49, 0x36, 0x00, 0x00, // "8"
		0x00, 0x00, 0x32, 0x49, 0x49, 0x3E, 0x00, 0x00, // "9"  
		0x00, 0x00, 0x3F, 0x44, 0x44, 0x3F, 0x00, 0x00, // "A"
		0x00, 0x00, 0x7F, 0x49, 0x49, 0x36, 0x00, 0x00, // "B"
		0x00, 0x00, 0x3E, 0x41, 0x41, 0x22, 0x00, 0x00, // "C"
		0x00, 0x00, 0x7F, 0x41, 0x41, 0x3E, 0x00, 0x00, // "D"
		0x00, 0x00, 0x7F, 0x49, 0x49, 0x41, 0x00, 0x00, // "E"
		0x00, 0x00, 0x7F, 0x48, 0x48, 0x40, 0x00, 0x00, // "F"
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // " "
	};

    public static void main(String[] args) throws Exception {  
        var pi4j = Pi4J.newAutoContext();  
        HC595 ledMatrix = new HC595(pi4j, DATA_PIN, LATCH_PIN, CLOCK_PIN);  
  
        try {  
			while(true){
				for(int j=0; j<500; j++){  //Repeat enough times to display the smiling face a period of time
					int x = 0x80;
					for(int i=0; i<8; i++){
						ledMatrix.shiftOut(HC595.Order.MSBFIRST, pic[i] & 0xff);  
						ledMatrix.shiftOut(HC595.Order.MSBFIRST, ~x);  
						ledMatrix.updateLatch();
						x >>= 1;           //display the next column
						Thread.sleep(1);
					}
				}
				for(int k=0; k<data.length-8; k++){  //sizeof(data) total number of "0-F" columns 
					for(int j=0; j<10; j++){ //times of repeated displaying LEDMatrix in every frame, the bigger the “j”, the longer the display time 
					    int x=0x80;          //Set the column information to start from the first column
						for(int i=k; i<8+k; i++){
							ledMatrix.shiftOut(HC595.Order.MSBFIRST, data[i] & 0xff);  
							ledMatrix.shiftOut(HC595.Order.MSBFIRST, ~x);  
							ledMatrix.updateLatch();
							x >>= 1;
							Thread.sleep(1);
						}
					}
				}
			}  
        } catch (InterruptedException e) {  
			Thread.currentThread().interrupt(); 
		} finally {  
            ledMatrix.shutdown();  
        }  
    }  
}

				