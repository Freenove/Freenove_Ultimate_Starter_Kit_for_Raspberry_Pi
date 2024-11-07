///usr/bin/env jbang "$0" "$@" ; exit $?

//DEPS org.slf4j:slf4j-api:2.0.12
//DEPS org.slf4j:slf4j-simple:2.0.12
//DEPS com.pi4j:pi4j-core:2.6.0
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0

import com.pi4j.Pi4J;  
import com.pi4j.context.Context;  
import com.pi4j.io.gpio.digital.DigitalOutput;  
import java.util.HashMap;  
import java.util.Map;  

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

public class BreathingLED {  
	private static int   LED_PIN = 17;
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
	
    public static void main(String[] args) throws Exception {  
        setPwmConfig(LED_PIN);  
		PWMController BreathingLed = pwmControllers.get(LED_PIN);  
        try {  
				while (true) {  
					double dutyCycle = 0.01;  
					while (dutyCycle < 1) {  
						BreathingLed.setPwmDutyCycle(dutyCycle);  
						dutyCycle += 0.01;  
						Thread.sleep(10);
					}  
					while (dutyCycle > 0) {  
						BreathingLed.setPwmDutyCycle(dutyCycle);  
						dutyCycle -= 0.01;  
						Thread.sleep(10);  
					}  
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