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
import java.util.HashMap;  
import java.util.Map;  
import java.util.Random; 

class PWMController implements Runnable {  
    private DigitalOutput pwm;  
	private int pwmFrequency;
	private double pwmDutyCycle;
    private boolean running = true;  
	private long period;  
	private long highTime;  
	private long lowTime;  
	
    public PWMController(DigitalOutput pwm) {  
        this.pwm = pwm;  
		this.pwmFrequency = 1000;
		this.pwmDutyCycle = 0.5;
		this.period = (int) (1000000 / pwmFrequency);  
		this.highTime = (int) (period * pwmDutyCycle);  
		this.lowTime = (int) (period - highTime);  
    }  
  
    @Override  
    public void run() {  
        while (running) {  
            if(highTime!=0){
				pwm.high();  
				delayUs(highTime); 
			}			
			if(lowTime!=0){
				pwm.low();  
				delayUs(lowTime);  
			} 		
        }  
    }  
  
	public void setPwmFrequency(int frequency) {  
        if(frequency!=0){
			this.pwmFrequency = frequency;
			this.period = (int) (1000000 / pwmFrequency);  
			this.highTime = (int) (period * pwmDutyCycle);  
			this.lowTime = (int) (period - highTime); 
		}
		else{
			this.pwmFrequency = 0;
			this.period = (int) (1000);  
			this.highTime = (int) (0);  
			this.lowTime = (int) (period - highTime); 
		}
    }  
	
	public void setPwmDutyCycle(double dutyCycle) {  
        this.pwmDutyCycle = dutyCycle;
		this.highTime = (int) (period * pwmDutyCycle);  
		this.lowTime = (int) (period - highTime); 
    } 

    private void delayUs(long us) {  
        long startTime = System.nanoTime();  
        long endTime = startTime + (us * 1000);  
        while (System.nanoTime() < endTime) {  
        }  
    }  
  
    public void requestStop() {  
        running = false;  
    }  
}

public class RainbowLED {  
    private static final Context pi4j = Pi4J.newAutoContext();  
    private static final Map<Integer, PWMController> pwmControllers = new HashMap<>();  
	
	public static void setPwmConfig(int pin) throws Exception {  
        DigitalOutput led = pi4j.dout().create(pin);  
        PWMController pwmController = new PWMController(led);  
        Thread pwmThread = new Thread(pwmController, "PWM LED Controller " + pin);  
        pwmControllers.put(pin, pwmController);  
        pwmThread.start();  
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {  
            pwmController.requestStop();  
            try {  
                pwmThread.join();  
            } catch (InterruptedException e) {  
                Thread.currentThread().interrupt();  
            }  
        }));  
    } 
	
	public static void ledSetup(int[] pins) {  
        for (int pin : pins) {  
            try {  
                setPwmConfig(pin);  
            } catch (Exception e) {  
                e.printStackTrace();  
            }  
        }  
    } 
	
	public static void setLedColor(int[] pins, int r, int g, int b) {  
        if (pins.length >= 3) {  
            PWMController red = pwmControllers.get(pins[0]);  
            PWMController green = pwmControllers.get(pins[1]);  
            PWMController blue = pwmControllers.get(pins[2]);  
            if (red != null) red.setPwmDutyCycle((double) r / 100.0);  
            if (green != null) green.setPwmDutyCycle((double) g / 100.0);  
            if (blue != null) blue.setPwmDutyCycle((double) b / 100.0);  
        }  
    } 
	
    public static void main(String[] args) throws Exception {  
		final var console = new Console();
		int[] LED_PINS = {17, 18, 27}; 
		Random random = new Random();	
		
        try {  
			ledSetup(LED_PINS);
			while (true) {  
				int red = random.nextInt(101);  
				int green = random.nextInt(101);  
				int blue = random.nextInt(101);  
				console.println("R:%d  G:%d, B:%d", red, green, blue);
				setLedColor(LED_PINS, red, green, blue);
				Thread.sleep(500);
			}  
        }  
		finally {  
            for (PWMController controller : pwmControllers.values()) {  
                controller.requestStop();  
            }  
            pi4j.shutdown();  
        }  
    }  
}