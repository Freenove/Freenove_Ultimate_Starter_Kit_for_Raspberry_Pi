///usr/bin/env jbang "$0" "$@" ; exit $?

//DEPS org.slf4j:slf4j-api:2.0.12
//DEPS org.slf4j:slf4j-simple:2.0.12
//DEPS com.pi4j:pi4j-core:2.6.0
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0

import com.pi4j.Pi4J;  
import com.pi4j.context.Context;  
import com.pi4j.io.gpio.digital.DigitalOutput;  
import com.pi4j.util.Console;  
import java.io.IOException;  

class StepMotor implements AutoCloseable {  
    private static final Context pi4j = Pi4J.newAutoContext();  
    private static final int[] MOTOR_PINS = {18, 23, 24, 25};  
    private final DigitalOutput[] motorPins;  
  
    public enum Direction {CW, CCW};  
    private final int[] CWStep = {0x01, 0x02, 0x04, 0x08};  
    private final int[] CCWStep = {0x08, 0x04, 0x02, 0x01};  
  
    public StepMotor() throws Exception {  
        motorPins = new DigitalOutput[MOTOR_PINS.length];  
        for (int i = 0; i < MOTOR_PINS.length; i++) {  
            motorPins[i] = pi4j.dout().create(MOTOR_PINS[i]);  
        }  
    }  
  
    public void moveOnePeriod(Direction dir, int ms) throws InterruptedException {  
        int[] stepSequence = dir == Direction.CW ? CWStep : CCWStep;  
        for (int step : stepSequence) {  
            for (int i = 0; i < MOTOR_PINS.length; i++) {  
                if ((step & (1 << i)) != 0) {  
                    motorPins[i].high();  
                } else {  
                    motorPins[i].low();  
                }  
            }  
            if (ms < 3) ms = 3;  
            Thread.sleep(ms);  
        }  
    }  
  
    public void moveSteps(Direction dir, int ms, int steps) throws InterruptedException {  
        for (int i = 0; i < steps; i++) {  
            moveOnePeriod(dir, ms);  
        }  
    }  
  
    public void motorStop() {  
        for (DigitalOutput pin : motorPins) {  
            pin.low();  
        }  
    }  
  
    @Override  
    public void close() throws Exception {  
        for (DigitalOutput pin : motorPins) {  
            if (pin != null) {  
                pin.low();  
            }  
        }  
        pi4j.shutdown();  
    }  
}

public class SteppingMotor {  
  
    public static void myPrintln(String format, Object... args) {  
        Console console = new Console();  
        console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));  
    }  
  
    public static void main(String[] args) {  
        StepMotor motorControl = null;  
        try {  
            motorControl = new StepMotor();  
            Runtime.getRuntime().addShutdownHook(new Thread(motorControl::motorStop));  
            while (true) {  
				myPrintln("Stepper motor is turning...");
                motorControl.moveSteps(StepMotor.Direction.CW, 3, 512);  
                Thread.sleep(500);  
				myPrintln("stepper motor is reversing...");
                motorControl.moveSteps(StepMotor.Direction.CCW, 3, 512);  
                Thread.sleep(500);  
            }  
        } catch (InterruptedException e) { 
            Thread.currentThread().interrupt(); 
            myPrintln("Interrupted: %s", e.getMessage());  
        } catch (Exception e) { 
            myPrintln("Error: %s", e.getMessage());  
        } finally {  
			if (motorControl != null) {  
				try {  
					motorControl.close();  
				} catch (Exception ex) {  
					ex.printStackTrace();  
				}  
			}  
		}  
    }  
}
