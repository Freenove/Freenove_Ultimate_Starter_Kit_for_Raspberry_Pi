// Shebang line for JBang to execute this script directly      
///usr/bin/env jbang "$0" "$@" ; exit $?      
  
// Dependencies for this script      
//DEPS org.slf4j:slf4j-api:2.0.12      
//DEPS org.slf4j:slf4j-simple:2.0.12      
//DEPS com.pi4j:pi4j-core:2.7.0      
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.7.0      
//DEPS com.pi4j:pi4j-plugin-gpiod:2.7.0      
//DEPS com.pi4j:pi4j-plugin-linuxfs:2.7.0      
  
// Importing necessary Pi4J and Java libraries  
import com.pi4j.Pi4J;    
import com.pi4j.context.Context;    
import com.pi4j.io.i2c.I2C;    
import com.pi4j.io.i2c.I2CConfig;    
import com.pi4j.io.i2c.I2CConfigBuilder;    
import com.pi4j.io.i2c.I2CProvider;    
import com.pi4j.util.Console;    
    
import java.io.File;    
import java.util.ArrayList;    
import java.util.Arrays;    
  
// MPU6050 class to interface with the MPU6050 sensor  
class MPU6050 {    
    // MPU6050 Register Addresses  
    private static final byte WHO_AM_I = 0x75;    
    private static final byte SMPLRT_DIV = 0x19;    
    private static final byte CONFIG = 0x1A;    
    private static final byte GYRO_CONFIG = 0x1B;    
    private static final byte ACCEL_CONFIG = 0x1C;    
    private static final byte PWR_MGMT_1 = 0x6B;    
    
    private static final byte ACCEL_XOUT_H = 0x3B;    
    private static final byte GYRO_XOUT_H = 0x43;    
    
    private I2C i2c;    
    private int bus;    
    private int address;    
    
    // Constructor to initialize MPU6050 with bus and address  
    public MPU6050(int bus, int address) {    
        this.bus = bus;    
        this.address = address;    
        initializeI2C();    
        initializeMPU6050();    
    }    
    
    // Constructor to initialize MPU6050 with bus string and address  
    public MPU6050(String busString, int address) {    
        this.address = address;    
        try {    
            this.bus = Integer.parseInt(busString.split("i2c-")[1]);    
        } catch (Exception e) {    
            this.bus = 1;    
        }    
        initializeI2C();    
        initializeMPU6050();    
    }    
    
    // Method to initialize I2C communication  
    private void initializeI2C() {    
        Context pi4j = Pi4J.newAutoContext();    
        I2CProvider i2CProvider = pi4j.provider("linuxfs-i2c");    
        I2CConfigBuilder i2cConfigBuilder = I2C.newConfigBuilder(pi4j).bus(bus);    
        I2CConfig i2cConfig = i2cConfigBuilder.device(address).build();    
        this.i2c = i2CProvider.create(i2cConfig);    
    }    
    
    // Static method to list all I2C devices  
    public static String[] listI2CDevices() {    
        ArrayList<String> devs = new ArrayList<>();    
        File dir = new File("/dev");    
        File[] files = dir.listFiles();    
        if (files != null) {    
            for (File file : files) {    
                if (file.getName().startsWith("i2c-")) {    
                    devs.add(file.getName());    
                }    
            }    
        }    
        String[] tmp = devs.toArray(new String[devs.size()]);    
        Arrays.sort(tmp);    
        return tmp;    
    }    
    
    // Method to initialize MPU6050 settings  
    private void initializeMPU6050() {    
        i2c.writeRegister(PWR_MGMT_1, 0x01);    
        i2c.writeRegister(SMPLRT_DIV, 0x00);    
        i2c.writeRegister(CONFIG, 0x00);    
        i2c.writeRegister(GYRO_CONFIG, 0x08);    
        i2c.writeRegister(ACCEL_CONFIG, 0x00);    
    }    
    
    // Method to read the WHO_AM_I register for device identification  
    public byte testWhoAmI() {    
        byte[] whoAmI = new byte[1];    
        i2c.readRegister(WHO_AM_I, whoAmI);    
        return whoAmI[0];    
    }    
    
    // Method to get raw accelerometer data  
    public int[] getRawAccel() {    
        int[] data = new int[3];    
        byte[] buffer = new byte[6];    
        i2c.readRegister(ACCEL_XOUT_H, buffer, buffer.length);    
        data[0] = (buffer[0] << 8) | (buffer[1] & 0xFF);    
        data[1] = (buffer[2] << 8) | (buffer[3] & 0xFF);    
        data[2] = (buffer[4] << 8) | (buffer[5] & 0xFF);   
        return data;    
    }    
    
    // Method to get raw gyroscope data  
    public int[] getRawGyro() {    
        int[] data = new int[3];    
        byte[] buffer = new byte[6];    
        i2c.readRegister(GYRO_XOUT_H, buffer, buffer.length);    
        data[0] = (buffer[0] << 8) | (buffer[1] & 0xFF);    
        data[1] = (buffer[2] << 8) | (buffer[3] & 0xFF);    
        data[2] = (buffer[4] << 8) | (buffer[5] & 0xFF);   
        return data;    
    }    
    
    // Method to close the I2C connection  
    public void close() {    
        i2c.close();    
    }    
}  
  
public class MPU6050RAW {  
    public static final int MPU6050_ADDRESS = 0x68;  
  
    public static void myPrintln(String format, Object... args) {  
        Console console = new Console();  
        console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));  
    }  
  
    public static void main(String[] args) {  
        MPU6050 mpu = null;  
        try {  
            mpu = new MPU6050(MPU6050.listI2CDevices()[0], MPU6050_ADDRESS);  
  
            // Test WHO AM I register  
            int whoAmI = mpu.testWhoAmI();  
            myPrintln("WHO AM I: 0x%02X", whoAmI);  
            if (whoAmI == MPU6050_ADDRESS) {  
                myPrintln("MPU6050 device identified correctly.");  
            } else {  
                myPrintln("Failed to identify MPU6050 device. Got: 0x%02X", whoAmI);  
            }  
  
            while (true) {  
                int[] accel = mpu.getRawAccel();  
                int[] gyro = mpu.getRawGyro();  
                myPrintln("a/g: %8d %8d %8d     %8d %10d %10d", 
                          accel[0], accel[1], accel[2], gyro[0], gyro[1], gyro[2]);  
                myPrintln("a/g:   %.2f g   %.2f g   %.2f g     %.2f d/s   %.2f d/s   %.2f d/s\n", 
                          (float)accel[0]/16384, (float)accel[1]/16384, (float)accel[2]/16384, 
                          (float)gyro[0]/131, (float)gyro[1]/131, (float)gyro[2]/131);  
                Thread.sleep(300);  
            }  
        } catch (InterruptedException e) {  
            e.printStackTrace();  
            Thread.currentThread().interrupt();  
        } finally {  
            if (mpu != null) {  
                mpu.close();  
            }  
        }  
    }  
}
