///usr/bin/env jbang "$0" "$@" ; exit $?  

//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  
//DEPS com.pi4j:pi4j-plugin-linuxfs:2.6.0  

import java.util.BitSet;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import com.pi4j.Pi4J;
import com.pi4j.boardinfo.util.BoardInfoHelper;
import com.pi4j.io.gpio.digital.DigitalInput;
import com.pi4j.io.gpio.digital.DigitalState;
import com.pi4j.io.gpio.digital.DigitalStateChangeEvent;
import com.pi4j.io.gpio.digital.DigitalStateChangeListener;
import com.pi4j.io.gpio.digital.PullResistance;
import com.pi4j.util.Console;
import com.pi4j.context.Context;
import com.pi4j.io.gpio.digital.DigitalOutput;

class GPIO {  
    // Constants for pin modes  
    public static final int INPUT = 0;          // Input mode  
    public static final int OUTPUT = 1;         // Output mode  
    public static final int INPUT_PULLUP = 2;   // Input with pull-up resistor  
    public static final int INPUT_PULLDOWN = 3; // Input with pull-down resistor  
  
    // Constants for pin states  
    public static final int LOW = 0;   // Low state  
    public static final int HIGH = 1;  // High state  
  
    // Constants for pin edge detection  
    public static final int NONE = 0;     // No edge detection  
    public static final int CHANGE = 1;   // Detect any edge change  
    public static final int FALLING = 2;  // Detect falling edge  
    public static final int RISING = 3;   // Detect rising edge  
  
    // Protected static context, likely for PI4J library  
    protected static Context pi4j;  
  
    // Protected method to check if the pin is valid  
    protected static void checkValidPin(int var0) {  
        if (var0 < 0) {  
            throw new RuntimeException("Operation not supported on this pin");  
        }  
    }  
  
    // Inner class representing the state of a GPIO pin  
    class GPIO_State {  
        public int state = 0;  
    }  
  
    // Private static maps to hold input and output pins  
    private static Map<Integer, DigitalInput> inputPins = new HashMap<>();  
    private static Map<Integer, DigitalOutput> outputPins = new HashMap<>();  
  
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
        if (inputPins.get(pin) == null) {  
            if (outputPins.get(pin) == null) {  
                return -1; // Pin not configured  
            } else {  
                return outputPins.get(pin).state().equals(HIGH) ? HIGH : LOW;  
            }  
        }  
        return inputPins.get(pin).state().equals(HIGH) ? HIGH : LOW;  
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
            default:  
                break;  
        }  
    }  
}

// Class Key: Define some of the properties of a Key  
class Key {  
    // Constant for no key being pressed (null character)  
    final char NO_KEY = '\0';  
      
    // Constants representing different states of a key  
    // IDLE: Key is not being pressed or released  
    // PRESSED: Key is initially pressed  
    // HOLD: Key is being held down  
    // RELEASED: Key has been released  
    final int IDLE = 0, PRESSED = 1, HOLD = 2, RELEASED = 3;  
      
    // Constants representing the open and closed state (possibly for a key switch)  
    final int OPEN = 0, CLOSED = 1;  
      
    // Variables to hold the key character, state, key code, and state change flag  
    char kchar; // The character representing the key  
    int kstate; // The current state of the key  
    int kcode;  // The key code (possibly related to hardware or system key codes)  
    boolean stateChanged; // Flag to indicate if the state of the key has changed  
      
    // Constructor to initialize the Key object  
    public Key() {  
        kchar = NO_KEY; // Initialize kchar to no key  
        kstate = IDLE;  // Initialize kstate to IDLE  
        kcode = -1;     // Initialize kcode to an invalid/unknown value  
        stateChanged = false; // Initialize stateChanged to false  
    }  
}

class Keypad {
    // Define some constants for key states and other values  
    final char NO_KEY = '\0'; // Represents no key being pressed  
    final int IDLE = 0, PRESSED = 1, HOLD = 2, RELEASED = 3; // Key states  
    final int OPEN = 0, CLOSED = 1; // Additional states (possibly for switch/connection status)  
    final int LIST_MAX = 10, MAPSIZE = 10; // Maximum number of keys and size of the bitmap  
    
    // Declare variables for keypad functionality  
    int[] bitMap = new int[MAPSIZE]; // Bitmap to track key states  
    Key[] key = new Key[LIST_MAX]; // Array of Key objects  
    long holdTime = 500, holdTimer = 0; // Hold time and timer for key holding  
    int[] rowPins, colPins; // Arrays to store row and column pin connections  
    int numRows, numCols; // Number of rows and columns in the keypad  
    char[] keymap; // User-defined keymap for key characters  
    long debounceTime = 10; // Debounce time to prevent false triggers  
    long startTime = System.nanoTime(); // Time when the keypad was initialized  
    
    // Constructor to initialize the Keypad with the given parameters  
    public Keypad(Context pi4jContext, char[] usrKeyMap, int[] rowPins, int[] colPins) {  
        GPIO.pi4j = pi4jContext;  
        keymap = usrKeyMap;  
        this.rowPins = rowPins; 
        this.colPins = colPins; 
        numRows = rowPins.length;  
        numCols = colPins.length;  
        for (int i = 0; i < LIST_MAX; i++) {  
            key[i] = new Key();  
        }  
        setPinMode();  
    } 

    // Method to get the key that is currently pressed  
    public char getKey() {  
        // If getKeys() returns true, and the first key's state has changed, and it is pressed  
        if (getKeys() && key[0].stateChanged && (key[0].kstate ==PRESSED)) {  
            // Return the character of the first key  
            return key[0].kchar;  
        }  
        // If no key is pressed, return NO_KEY  
        return NO_KEY;  
    }  
    
    // Method to check for key activity  
    public boolean getKeys() {  
        // Variable to track if there is any key activity  
        boolean keyActivity = false;  
        // Check if the time since the last debounce is greater than the debounce time  
        if ((System.nanoTime() - startTime) > (debounceTime * 1000000)) {  
            // Scan the keys  
            scanKeys();  
            // Update the key list and get the result  
            keyActivity = updateList();  
            // Reset the start time  
            startTime = System.nanoTime();  
        }  
        // Return the key activity status  
        return keyActivity;  
    }  
    
    // Method to set the pin modes for rows and columns  
    void setPinMode() {  
        // Set row pins to input mode  
        for (int i = 0; i < numRows; i++) {  
            GPIO.pinMode(rowPins[i], GPIO.INPUT);  
        }  
        // Set column pins to output mode  
        for (int i = 0; i < numCols; i++) {  
            GPIO.pinMode(colPins[i], GPIO.OUTPUT);  
        }  
    }  
    
    // Method to scan the keys  
    void scanKeys() {  
        // Loop through each column  
        for (int i = 0; i < numCols; i++) {  
            // Set the column pin to LOW to begin the pulse output  
            GPIO.digitalWrite(colPins[i], GPIO.LOW);  
            // Loop through each row  
            for (int j = 0; j < numRows; j++) {  
                // Read the row pin state (keypress is active low, so invert the result)  
                try {  
                    bitMap[j] = bitWrite(bitMap[j], i, (~GPIO.digitalRead(rowPins[j]) & 0x01));  
                } catch (Exception e) {  
                    // Print the stack trace if an exception occurs  
                    e.printStackTrace();  
                }  
            }  
            // Set the column pin to HIGH to end the pulse output  
            GPIO.digitalWrite(colPins[i], GPIO.HIGH);  
        }  
    }  
    
    // Method to update the key list  
    boolean updateList() {  
        // Variable to track if there is any activity  
        boolean anyActivity = false;  
        // Reset the keys that are in IDLE state  
        for (int i = 0; i < LIST_MAX; i++) {  
            if (key[i].kstate == IDLE) {  
                key[i].kchar = NO_KEY;  
                key[i].kcode = -1;  
                key[i].stateChanged = false;  
            }  
        }  
        // Loop through each row and column to check for key presses  
        for (int r = 0; r < numRows; r++) {  
            for (int c = 0; c < numCols; c++) {  
                // Get the button state from the bitmap  
                boolean button = bitRead(bitMap[r], c);  
                // Get the key character and key code from the keymap  
                char keyChar = keymap[r * numCols + c];  
                int keycode = r * numCols + c;  
                // Find the index of the key in the key list  
                int idx = findInList(keycode);  
                // If the key is already in the list, update its state  
                if (idx > -1) {  
                    nextKeyState(idx, button);  
                }  
                // If the key is not in the list and the button is pressed, add it to the list  
                if ((idx == -1) && button) {  
                    for (int i = 0; i < LIST_MAX; i++) {  
                        if (key[i].kchar == NO_KEY) {  
                            key[i].kchar = keyChar;  
                            key[i].kcode = keycode;  
                            key[i].kstate = IDLE;  
                            nextKeyState(i, button);  
                            break;  
                        }  
                    }  
                }  
            }  
        }  
        // Check if any key's state has changed  
        for (int i = 0; i < LIST_MAX; i++) {  
            if (key[i].stateChanged) {  
                anyActivity = true;  
            }  
        }  
        // Return the activity status  
        return anyActivity;  
    }  
    
    // Method to handle the next state of a key  
    private void nextKeyState(int idx, boolean button) {  
        // Reset the state changed flag  
        key[idx].stateChanged = false;  
        // Switch based on the current state of the key  
        switch (key[idx].kstate) {  
            case IDLE:  
                // If the button is pressed, transition to the PRESSED state  
                if (button) {  
                    transitionTo(idx, PRESSED);  
                    holdTimer = System.nanoTime();  
                }  
                break;  
            case PRESSED:  
                // If the button has been pressed for longer than the hold time, transition to the HOLD state  
                if ((System.nanoTime() - holdTimer) > (holdTime * 1000000)) {  
                    transitionTo(idx, HOLD);  
                }  
                // If the button is released, transition to the RELEASED state  
                else if (!button) {  
                    transitionTo(idx, RELEASED);  
                }  
                break;  
            case HOLD:  
                // If the button is released, transition to the RELEASED state  
                if (!button) {  
                    transitionTo(idx, RELEASED);  
                }  
                break;  
            case RELEASED:  
                // Transition to the IDLE state  
                transitionTo(idx, IDLE);  
                break;  
        }  
    }  
    
    // Method to transition a key to a new state  
    private void transitionTo(int idx, int nextState) {  
        // Set the new state  
        key[idx].kstate = nextState;  
        // Set the state changed flag to true  
        key[idx].stateChanged = true;  
    }  
    
    // Method to find a key in the key list based on its key code  
    private int findInList(int keycode) {  
        // Loop through the key list  
        for (int i = 0; i < LIST_MAX; i++) {  
            // If the key code matches, return the index  
            if (key[i].kcode == keycode) {  
                return i;  
            }  
        }  
        // If the key is not found, return -1  
        return -1;  
    }

    // Set the debounce time in milliseconds  
    public void setDebounceTime(int ms) {  
        debounceTime = ms;  
    }  

    // Set the hold time in milliseconds  
    public void setHoldTime(int ms) {  
        holdTime = ms;  
    }  

    // Check if a specific key is pressed  
    public boolean isPressed(char keyChar) {  
        for (byte i = 0; i < LIST_MAX; i++) {  
            if (key[i].kchar == keyChar) {  
                if ((key[i].kstate == PRESSED) && key[i].stateChanged)  
                    return true;  
            }  
        }  
        return false;  
    }  

    // Wait until a key is pressed and return the key character  
    public char waitForKey() {  
        char waitKey = NO_KEY;  
        while ((waitKey = getKey()) == NO_KEY);  // Block until a key is pressed  
        return waitKey;  
    }  

    // Get the current state of the first key in the list  
    public int getState() {  
        return key[0].kstate;  
    }  

    // Check if the state of the first key in the list has changed  
    boolean keyStateChanged() {  
        return key[0].stateChanged;  
    }  

    // Write a bit to a specific position in an integer  
    private int bitWrite(int x, int n, int b) {  
        if (b != 0) {  
            x |= (1 << n);  // Set the nth bit to 1  
        } else {  
            x &= (~(1 << n));  // Clear the nth bit  
        }  
        return x;  
    }  

    // Read a bit from a specific position in an integer  
    private boolean bitRead(int x, int n) {  
        if (((x >> n) & 1) == 1) {  // Check if the nth bit is set  
            return true;  
        } else {  
            return false;  
        }  
    }
}

public class MatrixKeypad {  
    // Array of key codes corresponding to the keypad buttons  
    final static char[] keys = {  
        '1', '2', '3', 'A',   
        '4', '5', '6', 'B',   
        '7', '8', '9', 'C',   
        '*', '0', '#', 'D'    
    };  
  
    // Pinouts for the rows of the keypad  
    final static int[] rowsPins = {18, 23, 24, 25};  
    // Pinouts for the columns of the keypad  
    final static int[] colsPins = {10, 22, 27, 17};  
  
    // Create a Pi4J context for GPIO operations  
    private static final Context pi4j = Pi4J.newAutoContext();  
    // Initialize a Keypad object with the specified keys, row pins, and column pins  
    static Keypad kp = new Keypad(pi4j, keys, rowsPins, colsPins);  
  
    // Custom print method to output text in green color  
    public static void myPrintln(String format, Object... args) {  
        Console console = new Console();  
        console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));  
    }  
  
    // Main method  
    public static void main(String[] args) throws Exception {  
        // Add a shutdown hook to ensure Pi4J context is properly shut down  
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {  
            System.out.println("Shutting down Pi4J context...");  
            if (pi4j != null) {  
                pi4j.shutdown();  
            }  
        }));  
  
        try {  
            // Infinite loop to continuously read keys from the keypad  
            while (true) {  
                // Get the currently pressed key  
                char kkey = kp.getKey();  
                // If a key is pressed (not the null character '\0'), print it  
                if (kkey != '\0') {  
                    myPrintln("key:%c", kkey);  
                }  
                // Sleep for 10 milliseconds to prevent excessive CPU usage  
                Thread.sleep(10);  
            }  
        } catch (InterruptedException e) {  
            // If the thread is interrupted, print a message and exit  
            myPrintln("Interrupted. Exiting...");  
        } finally {  
            // Empty finally block; the shutdown hook will handle resource cleanup  
        }  
    }  
}