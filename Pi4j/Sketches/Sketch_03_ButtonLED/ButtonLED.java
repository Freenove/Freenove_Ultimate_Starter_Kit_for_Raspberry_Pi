///usr/bin/env jbang "$0" "$@" ; exit $?

//DEPS org.slf4j:slf4j-api:2.0.12
//DEPS org.slf4j:slf4j-simple:2.0.12
//DEPS com.pi4j:pi4j-core:2.6.0
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0

import com.pi4j.Pi4J;
import com.pi4j.io.gpio.digital.DigitalState;
import com.pi4j.util.Console;

public class ButtonLED{

    private static final int PIN_BUTTON = 18;
    private static final int PIN_LED = 17; 

    public static void main(String[] args) throws Exception {
        final var console = new Console();
        var pi4j = Pi4J.newAutoContext();
		
		var led = pi4j.dout().create(PIN_LED);  
        var button = pi4j.din().create(PIN_BUTTON);
		
        button.addListener(e -> {
            if (e.state() == DigitalState.LOW) {
                console.println("Button was pressed. Blue LED on.");
				led.high();
            }
			else if(e.state() == DigitalState.HIGH){
				console.println("Button was released. Blue LED off.");
				led.low();
			}
        });
        
		try{
            while (true) {
				Thread.sleep(500);
            }
        }
        finally{
            pi4j.shutdown();
        }
    }
}

