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

class Servo {
    private final int pin;
    private final PWMController pwmController;
    private final Context pi4j;

    public Servo(int pin) throws Exception {
        this.pin = pin;
        this.pi4j = Pi4J.newAutoContext();
        DigitalOutput pwm = pi4j.dout().create(pin);
        this.pwmController = new PWMController(pwm);

        Thread pwmThread = new Thread(pwmController, "PWM Controller for Servo on PIN " + pin);
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

    public void setFrequency(int frequency) {
        pwmController.setPwmFrequency(frequency);
    }

    public void setDutyCycle(double dutyCycle) {
        pwmController.setPwmDutyCycle(dutyCycle);
    }

    public void setAngle(int angle) {
        if (angle > 180 || angle < 0) {
            return;
        }
        double dutyCycle = (((double) angle / 180.0 * 2) + 0.5) / 20;
        pwmController.setPwmDutyCycle(dutyCycle);
    }

    public void shutdown() {
        pwmController.requestStop();
        pi4j.shutdown();
    }
}

public class Sweep {
    private static int SERVO_PIN = 18;
    private static final Map<Integer, Servo> servoMap = new HashMap<>();

    public static void myPrintln(String format, Object... args) {
        Console console = new Console();
        console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));
    }

    public static void main(String[] args) throws Exception {
        servoMap.put(SERVO_PIN, new Servo(SERVO_PIN));
        Servo servo = servoMap.get(SERVO_PIN);
        servo.setFrequency(50);
        servo.setDutyCycle(0.075);

        myPrintln("Start sweeping ...");
        Thread.sleep(3000);

        try {
            while (true) {
                for (int i = 0; i < 180; i++) {
                    servo.setAngle(i);
                    myPrintln("The Angle is %d", i);
                    Thread.sleep(20);
                }
                for (int i = 180; i > 0; i--) {
                    servo.setAngle(i);
                    myPrintln("The Angle is %d", i);
                    Thread.sleep(20);
                }
            }
        } finally {
            if (servo != null) {
                servo.shutdown();
            }
        }
    }
}
