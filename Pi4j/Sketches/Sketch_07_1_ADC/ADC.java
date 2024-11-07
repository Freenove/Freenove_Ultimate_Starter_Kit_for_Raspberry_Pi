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

public class ADC {

    public static void myPrintln(String format, Object... args) {
        Console console = new Console();
        console.println(String.format("\u001B[32m" + format + "\u001B[0m", args));
    }

    public static void main(String[] args) throws Exception {
        Context pi4j = Pi4J.newAutoContext();
        I2CProvider i2CProvider = pi4j.provider("linuxfs-i2c");
        try {
            int ADC_CHIP_ADDR = 0x48;
            ADCDevice adcDevice = new ADCDevice(pi4j, i2CProvider, ADC_CHIP_ADDR);
            if (adcDevice.detectI2C()) {
                int ADC_CHANNEL = 0;
                while (true) {
                    int adcValue = adcDevice.analogRead(ADC_CHANNEL);
                    if (adcValue != -1) {
                        myPrintln("ADC Channel %d Value:%d", ADC_CHANNEL, adcValue);
                    } 
                    else {
                        myPrintln("Failed to read data from ADC.");
                    }
                    Thread.sleep(100);
                }
            } 
            else {
                myPrintln("ADS7830 device not detected at address 0x" + Integer.toHexString(ADC_CHIP_ADDR));
            }
        } 
        finally {
            pi4j.shutdown();
        }
    }
}
