import java.io.BufferedReader;  
import java.io.FileReader;  
import java.io.IOException;  

public class DHT11 {  
    private static final String TEMP_FILE_PATH = "/sys/bus/iio/devices/iio:device0/in_temp_input";  
    private static final String HUMIDITY_FILE_PATH = "/sys/bus/iio/devices/iio:device0/in_humidityrelative_input";  
    private static final double TEMP_SCALE = 0.001;   
    private static final double HUMIDITY_SCALE = 0.001;   
  
    public double readTemperature() throws IOException {  
        String tempLine = readFile(TEMP_FILE_PATH);  
        return Double.parseDouble(tempLine) * TEMP_SCALE;  
    }  
  
    public double readHumidity() throws IOException {  
        String humidityLine = readFile(HUMIDITY_FILE_PATH);  
        return Double.parseDouble(humidityLine) * HUMIDITY_SCALE;  
    }  
  
    private String readFile(String filePath) throws IOException {  
        StringBuilder content = new StringBuilder();  
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {  
            String line;  
            while ((line = br.readLine()) != null) {  
                content.append(line);  
            }  
        }  
        return content.toString().trim();  
    }  
  
    public static void main(String[] args) {  
        DHT11 dht11 = new DHT11();  
        while (true) {  
            try {  
                double temperature = dht11.readTemperature();  
                double humidity = dht11.readHumidity(); 
				if (humidity >= 0 && humidity <= 100) {  
					System.out.println("Temperature: " + temperature + "°C");  
					System.out.println("Humidity: " + humidity + "%");  
				}
				Thread.sleep(2000);
            } catch (IOException e) {  
                if (!"Input/output error".equals(e.getMessage())) {  
                    e.printStackTrace();  
                } 
            } catch (InterruptedException e) {  
                Thread.currentThread().interrupt();  
				break;
            }  
        }  
    }  
}
