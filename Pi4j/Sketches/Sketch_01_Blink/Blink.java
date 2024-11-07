///usr/bin/env jbang "$0" "$@" ; exit $?  

//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  

import com.pi4j.Pi4J; 
import com.pi4j.util.Console; 
  
public class Blink {  
    private static final int PIN_LED = 17;   
  
    public static void main(String[] args) throws Exception {  
        final var console = new Console();  
        var pi4j = Pi4J.newAutoContext();  
        var led = pi4j.dout().create(PIN_LED);  
          
        try {  
            while (true) {  
                console.println("LED low"); 
                led.low(); 
                Thread.sleep(1000); 
                console.println("LED high"); 
                led.high(); 
                Thread.sleep(1000); 
            }  
        } finally {  
            pi4j.shutdown();  
        }  
    }  
}
