///usr/bin/env jbang "$0" "$@" ; exit $?

//DEPS org.slf4j:slf4j-api:2.0.12
//DEPS org.slf4j:slf4j-simple:2.0.12
//DEPS com.pi4j:pi4j-core:2.6.0
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0

import com.pi4j.Pi4J;
import com.pi4j.context.Context;
import com.pi4j.io.gpio.digital.DigitalState;
import com.pi4j.io.gpio.digital.DigitalInput;
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
            if (highTime != 0) {
                pwm.high();
                delayUs(highTime);
            }
            if (lowTime != 0) {
                pwm.low();
                delayUs(lowTime);
            }
        }
    }

    public void setPwmFrequency(int frequency) {
        if (frequency != 0) {
            this.pwmFrequency = frequency;
            this.period = (int) (1000000 / pwmFrequency);
            this.highTime = (int) (period * pwmDutyCycle);
            this.lowTime = (int) (period - highTime);
        } else {
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

public class Alertor {
    private static final Context pi4j = Pi4J.newAutoContext();
    private static final Map<Integer, PWMController> pwmControllers = new HashMap<>();
    private static volatile int buttonState = 0;
    private static int PIN_BUTTON = 18;
    private static int PIN_BUZZER = 17;

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

    public static void myPrintln(String tempText) {
        Console console = new Console();
        console.println("\u001B[32m" + tempText + "\u001B[0m");
    }

    public static void main(String[] args) throws Exception {

        DigitalInput button = pi4j.din().create(PIN_BUTTON);
        button.addListener(e -> {
            buttonState = e.state() == DigitalState.LOW ? 1 : 0;
        });

        setPwmConfig(PIN_BUZZER);
        PWMController buzzer = pwmControllers.get(PIN_BUZZER);
        buzzer.setPwmFrequency(0);
        buzzer.setPwmDutyCycle(0.5);

        try {
            while (true) {
                if (buttonState == 1) {
                    myPrintln("buzzer turned on.  >>>");
                    buzzer.setPwmFrequency(1000);
                } else {
                    myPrintln("buzzer turned off. >>>");
                    buzzer.setPwmFrequency(0);
                }
                Thread.sleep(100);
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
