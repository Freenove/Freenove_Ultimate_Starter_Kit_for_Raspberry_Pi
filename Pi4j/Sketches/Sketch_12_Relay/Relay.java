///usr/bin/env jbang "$0" "$@" ; exit $?

//DEPS org.slf4j:slf4j-api:2.0.12
//DEPS org.slf4j:slf4j-simple:2.0.12
//DEPS com.pi4j:pi4j-core:2.6.0
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0

import com.pi4j.Pi4J;
import com.pi4j.io.gpio.digital.DigitalState;
import com.pi4j.io.gpio.digital.DigitalOutput;    
import com.pi4j.util.Console;
import java.util.concurrent.atomic.AtomicBoolean; 

public class Relay{

    private static final int PIN_BUTTON = 18;
    private static final int PIN_RELAY = 17; 
	private static final AtomicBoolean relayState = new AtomicBoolean(false);  

	public static void myPrintln(String format, Object... args) {    
		Console console = new Console();  
		console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));   
	}
	
	private static void updateRelay(DigitalOutput relay, boolean state) {  
        if (state) {  
            relay.high();  
        } else {  
            relay.low();  
        }  
    }  
	
    public static void main(String[] args) throws Exception {
        final var console = new Console();
        var pi4j = Pi4J.newAutoContext();
		
		var relay = pi4j.dout().create(PIN_RELAY);  
        var button = pi4j.din().create(PIN_BUTTON);
		
        button.addListener(e -> {
            if (e.state() == DigitalState.LOW) {
				relayState.set(!relayState.get());  
				myPrintln("Button was pressed. Relay state: %s", relayState.get()); 
				updateRelay(relay, relayState.get());  
            }
        });
        
		try{
			myPrintln("The button gpio is %d, the relay gpio is %d", PIN_BUTTON, PIN_RELAY); 
            while (true) {
				Thread.sleep(500);
            }
        }
        finally{
            pi4j.shutdown();
        }
    }
}

