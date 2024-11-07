///usr/bin/env jbang "$0" "$@" ; exit $?  
  
//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  
  
import com.pi4j.Pi4J;  
import com.pi4j.io.gpio.digital.DigitalOutput;  
import com.pi4j.util.Console;  
  
public class FlowingLight {  
    // Define the GPIO pin number for the LED.
    private static final int[] LED_PINS = {17, 18, 27, 22, 23, 24, 25, 2, 3, 8};  
  
    public static void main(String[] args) throws Exception {  
        final var console = new Console();  
        var pi4j = Pi4J.newAutoContext();  
        
        DigitalOutput[] leds = new DigitalOutput[LED_PINS.length];  
        for (int i = 0; i < LED_PINS.length; i++) {  
            leds[i] = pi4j.dout().create(LED_PINS[i]);  
        }  
  
        try {  
            int currentLed = 0; 
            while (true) {  
                console.println("LED " + LED_PINS[currentLed] + " is ON");  
                for (DigitalOutput led : leds) {  
                    led.low();  
                }  
                leds[currentLed].high();  
                Thread.sleep(100);  
                currentLed = (currentLed + 1) % LED_PINS.length;  
            }  
        } finally {  
            pi4j.shutdown(); 
        }  
    }  
}
