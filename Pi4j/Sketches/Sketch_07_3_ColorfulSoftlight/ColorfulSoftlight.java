///usr/bin/env jbang "$0" "$@" ; exit $?  
  
//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  
//DEPS com.pi4j:pi4j-plugin-linuxfs:2.6.0  

import com.pi4j.Pi4J;  
import com.pi4j.context.Context;  
import com.pi4j.io.i2c.I2C;  
import com.pi4j.io.i2c.I2CConfig;  
import com.pi4j.io.i2c.I2CProvider;  
import com.pi4j.util.Console;  
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

class ADCDevice {  
    private final I2C adcChip;  
    private final int adcChipAddr;  
  
    public ADCDevice(Context pi4j, I2CProvider provider, int adcChipAddr) throws Exception {  
        this.adcChipAddr = adcChipAddr;  
        I2CConfig i2cConfig = I2C.newConfigBuilder(pi4j).id("ADCDevice").bus(1).device(adcChipAddr).build();  
        this.adcChip = provider.create(i2cConfig);  
    }  
  
    public boolean detectI2C() throws Exception {  
        try {  
            adcChip.write(0);  
            byte[] data = new byte[1];  
            int bytesRead = adcChip.read(data, 0, 1);  
            return bytesRead == 1;  
        } catch (Exception e) {  
            return false;  
        }  
    }  
  
    public int analogRead(int chn) {  
        byte command = (byte) (0x84 | (((chn << 2 | chn >> 1) & 0x07) << 4));  
        adcChip.write(command);  
        byte[] data = new byte[1];  
        int bytesRead = adcChip.read(data, 0, 1);  
        if (bytesRead == 1) {  
            int adcValue = data[0] & 0xFF;  
            return adcValue;  
        } else {  
            return -1;  
        }  
    }  
}

public class ColorfulSoftlight{
	private static int   LED_PIN = 17;
	private static int   ADC_CHIP_ADDR = 0x48; 
    private static final Context pi4j = Pi4J.newAutoContext();  
    private static final Map<Integer, PWMController> pwmControllers = new HashMap<>();  
	
	public static void setPwmConfig(int pin) throws Exception {  
        DigitalOutput pwm = pi4j.dout().create(pin);  
        PWMController pwmController = new PWMController(pwm);  
        Thread pwmThread = new Thread(pwmController, "PWM Controller " + pin);  
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
	
	public static void myPrintln(String format, Object... args) {    
		Console console = new Console();  
		console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));   
	}
	
	public static void main(String[] args) throws Exception {  
        Context pi4j = Pi4J.newAutoContext();  
        I2CProvider i2CProvider = pi4j.provider("linuxfs-i2c");
		
		int[] ADC_CHN =  {0, 1, 2}; 
		int[] LED_PINS = {17, 27, 22}; 
		for (int pin : LED_PINS) {  
            setPwmConfig(pin);  
        } 
		PWMController red_led = pwmControllers.get(LED_PINS[0]); 
		PWMController green_led = pwmControllers.get(LED_PINS[1]); 
		PWMController blue_led = pwmControllers.get(LED_PINS[2]); 
		
        try {  
            ADCDevice adc = new ADCDevice(pi4j, i2CProvider, ADC_CHIP_ADDR);  
            if (adc.detectI2C()) {  
                while (true) {  
					int val_Red = adc.analogRead(ADC_CHN[0]);  
					int val_Green = adc.analogRead(ADC_CHN[1]); 
					int val_Blue = adc.analogRead(ADC_CHN[2]); 
					
					red_led.setPwmDutyCycle(1-(double)(val_Red/255.0));
                    green_led.setPwmDutyCycle(1-(double)(val_Green/255.0));
					blue_led.setPwmDutyCycle(1-(double)(val_Blue/255.0));
					
					myPrintln("ADC value val_Red:%d, val_Green:%d, val_Blue:%d", val_Red, val_Green, val_Blue);
                    Thread.sleep(100);  
                }  
            } else {  
                myPrintln("ADS7830 device not detected at address 0x" + Integer.toHexString(ADC_CHIP_ADDR));  
            }  
        } finally {  
            pi4j.shutdown();  
        }  
    }  
}