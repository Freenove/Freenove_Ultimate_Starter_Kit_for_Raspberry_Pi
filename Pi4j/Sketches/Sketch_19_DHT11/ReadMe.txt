If nothing happens when running the code, or the following error is reported:
	java.io.FileNotFoundException: /sys/bus/iio/devices/iio:device0/in_temp_input (No such file or directory)
		at java.base/java.io.FileInputStream.open0(Native Method)
		at java.base/java.io.FileInputStream.open(FileInputStream.java:216)
		at java.base/java.io.FileInputStream.<init>(FileInputStream.java:157)
		at java.base/java.io.FileInputStream.<init>(FileInputStream.java:111)
		at java.base/java.io.FileReader.<init>(FileReader.java:60)
		at DHT11.readFile(DHT11.java:26)
		at DHT11.readTemperature(DHT11.java:15)
		at DHT11.main(DHT11.java:39)

Please follow the steps below to do so:
	1, Use the instructions to open the config.txt: sudo nano/boot/firmware/config.txt

	2, Add a line at the bottom of config.txt: dtoverlay=dht11,gpiopin=17

	3, Save and exit config.txt, then restart the Raspberry PI.

