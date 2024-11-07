///usr/bin/env jbang "$0" "$@" ; exit $?  
  
// Specify dependencies for the project  
//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  
//DEPS com.pi4j:pi4j-plugin-linuxfs:2.6.0  
  
// Import necessary classes and interfaces  
import com.pi4j.Pi4J;  
import com.pi4j.context.Context;  
import com.pi4j.io.gpio.digital.DigitalInput;  
import com.pi4j.io.gpio.digital.DigitalOutput;  
import com.pi4j.io.gpio.digital.PullResistance;  
import com.pi4j.util.Console;  
import java.util.Map;  
import java.util.HashMap;  
  
// Class to handle GPIO pin operations  
class GPIO {  
    // Constants for pin modes  
    public static final int INPUT = 0;          // Input mode  
    public static final int OUTPUT = 1;         // Output mode  
    public static final int INPUT_PULLUP = 2;   // Input with pull-up resistor  
    public static final int INPUT_PULLDOWN = 3; // Input with pull-down resistor  
  
    // Constants for pin states  
    public static final int LOW = 0;   // Low state  
    public static final int HIGH = 1;  // High state  
  
    // Static context for Pi4J library  
    protected static Context pi4j;  
  
    // Maps to store input and output pins  
    public static Map<Integer, DigitalInput> inputPins = new HashMap<>();  
    public static Map<Integer, DigitalOutput> outputPins = new HashMap<>();  
  
    // Method to check if the pin is valid  
    protected static void checkValidPin(int pin) {  
        if (pin < 0) {  
            throw new RuntimeException("Operation not supported on this pin");  
        }  
    }  
  
    // Method to set the mode of a GPIO pin  
    public static void pinMode(int pin, int mode) {  
        checkValidPin(pin);  
        switch (mode) {  
            case INPUT:  
            case INPUT_PULLUP:  
            case INPUT_PULLDOWN:  
                // Configure the input pin settings  
                var config = DigitalInput.newConfigBuilder(pi4j).address(pin);  
                switch (mode) {  
                    case INPUT_PULLUP:  
                        config.pull(PullResistance.PULL_UP);  
                        break;  
                    case INPUT_PULLDOWN:  
                        config.pull(PullResistance.PULL_DOWN);  
                        break;  
                    default:  
                        config.pull(PullResistance.OFF);  
                        break;  
                }  
                config.build();  
                DigitalInput input = pi4j.din().create(config);  
                inputPins.put(pin, input);  
                break;  
            case OUTPUT:  
                // Configure the output pin  
                DigitalOutput output = pi4j.dout().create(pin);  
                outputPins.put(pin, output);  
                break;  
        }  
    }  
  
    // Method to read the digital state of a GPIO pin  
    public static int digitalRead(int pin) {  
        checkValidPin(pin);  
        if (inputPins.get(pin) != null) {  
            return inputPins.get(pin).state().equals(HIGH) ? HIGH : LOW;  
        }  
        if (outputPins.get(pin) != null) {  
            return outputPins.get(pin).state().equals(HIGH) ? HIGH : LOW;  
        }  
        return -1; // Pin not configured  
    }  
  
    // Method to write a digital state to a GPIO pin  
    public static void digitalWrite(int pin, int val) {  
        checkValidPin(pin);  
        switch (val) {  
            case HIGH:  
                outputPins.get(pin).high();  
                break;  
            case LOW:  
                outputPins.get(pin).low();  
                break;  
        }  
    }  
}  
  
// Class to handle ultrasonic distance measurements  
class Ultrasonic {  
    private final int trigPin;  // Trigger pin  
    private final int echoPin;  // Echo pin  
    private final DigitalOutput trigOutput;  // Trigger output  
    private final DigitalInput echoInput;  // Echo input  
    private static final int MAX_DISTANCE = 300;  // Maximum distance in centimeters  
    private static final float US_PER_CM = 58.8f;  // Microseconds per centimeter  
  
    // Constructor to initialize the ultrasonic sensor  
    public Ultrasonic(int trigPin, int echoPin) {  
        this.trigPin = trigPin;  
        this.echoPin = echoPin;  
        GPIO.pinMode(trigPin, GPIO.OUTPUT);  
        GPIO.pinMode(echoPin, GPIO.INPUT);  
        this.trigOutput = GPIO.outputPins.get(trigPin);  
        this.echoInput = GPIO.inputPins.get(echoPin);  
        if (this.trigOutput == null || this.echoInput == null) {  
            throw new RuntimeException("Failed to initialize GPIO pins");  
        }  
    }  
  
    // Method to delay execution for a specified number of microseconds  
    public static void delayMicroseconds(long us) {  
        long startTime = System.nanoTime();  
        long endTime = startTime + (us * 1000);  
        while (System.nanoTime() < endTime) {  
        }  
    }  
  
    // Method to measure the distance using the ultrasonic sensor  
    public float measureDistance() {  
        trigOutput.high();  
        delayMicroseconds(10);  
        trigOutput.low();  
  
        int duration = pulseIn(echoPin, GPIO.HIGH, MAX_DISTANCE * 60);  
        if (duration < (MAX_DISTANCE * 60)) {  
            return duration / US_PER_CM;  
        } else {  
            return -1; // No object detected within the maximum distance  
        }  
    }  
  
    // Private method to measure the pulse duration  
    private int pulseIn(int pin, int level, int timeout) {  
        long startTime = System.nanoTime();  
        long endTime = startTime + (timeout * 1000);  
        int duration = 0;  
        while (System.nanoTime() < endTime && GPIO.digitalRead(pin) != level) {  
        }  
        if (GPIO.digitalRead(pin) == level) {  
            startTime = System.nanoTime();  
            while (System.nanoTime() < endTime && GPIO.digitalRead(pin) == level) {  
                duration++;  
            }  
            duration = (int) ((System.nanoTime() - startTime) / 1000);  
        }  
        return duration;  
    }  
}  
  
// Main class to run the ultrasonic ranging program  
public class UltrasonicRanging {  
    // Method to print text in green color  
    public static void myPrintln(String format, Object... args) {  
        Console console = new Console();  
        console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));  
    }  
  
    // Main method to start the program  
    public static void main(String[] args) throws Exception {  
        try {  
            // Initialize the Pi4J context  
            GPIO.pi4j = Pi4J.newAutoContext();  
            // Create an instance of the Ultrasonic class  
            Ultrasonic ultrasonic = new Ultrasonic(23, 24);  
            // Continuously measure and print the distance  
            while (true) {  
                float distance = ultrasonic.measureDistance();  
                if (distance != -1) {  
                    myPrintln("Distance: %.2fcm", distance);  
                } else {  
                    myPrintln("No object detected within the maximum distance.");  
                }  
                Thread.sleep(100); // Sleep for 100 milliseconds to avoid flooding the console  
            }  
        } catch (InterruptedException e) {  
            myPrintln("Interrupted. Exiting...");  
        } finally {  
            // Shutdown the Pi4J context  
            if (GPIO.pi4j != null) {  
                GPIO.pi4j.shutdown();  
            }  
        }  
    }  
}