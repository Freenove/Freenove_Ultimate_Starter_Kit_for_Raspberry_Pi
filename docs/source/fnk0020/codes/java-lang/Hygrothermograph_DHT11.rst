##############################################################################
Chapter Hygrothermograph DHT11
##############################################################################

In this chapter, we will learn about a commonly used sensor called a Hygrothermograph DHT11.

Project Hygrothermograph
****************************************************************

Hygrothermograph is an important tool in our lives to give us data on the temperature and humidity in our environment. In this project, we will use the RPi to read Temperature and Humidity data of the DHT11 Module.

Component List
================================================================

+-------------------------------------------------+-------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |                                                 |     
|                                                 | Jumper Wires x4                                 |       
|2. GPIO Extension Board & Ribbon Cable x1        |                                                 |       
|                                                 |  |jumper-wire|                                  |                                                            
|3. Breadboard x1                                 |                                                 |                                                                 
+-------------------------------------------------+-------------------------------------------------+
| DHT11 x1                                        | Resistor 10kΩ x1                                |
|                                                 |                                                 |
|  |DHT11|                                        |  |Resistor-10kΩ|                                |
+-------------------------------------------------+-------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
.. |Resistor-10kΩ| image:: ../_static/imgs/Resistor-10kΩ.png
    :width: 15%
.. |DHT11| image:: ../_static/imgs/DHT11.png
    :width: 50%

Component knowledge
================================================================

The Temperature & Humidity Sensor DHT11 is a compound temperature & humidity sensor, and the output digital signal has been calibrated by its manufacturer.

.. image:: ../_static/imgs/DHT11_1.png
    :align: center

After being powered up, it will initialize in 1 second. Its operating voltage is within the range of 3.3V-5.5V.

The SDA pin is a data pin, which is used to communicate with other devices. 

The NC pin (Not Connected Pin) are a type of pin found on various integrated circuit packages. Those pins have no functional purpose to the outside circuit (but may have an unknown functionality during manufacture and test). Those pins should not be connected to any of the circuit connections.

Circuit
================================================================

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |DHT11_Sc|                                                                                   |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         |
|                                                                                                |
|   |DHT11_Fr|                                                                                   | 
+------------------------------------------------------------------------------------------------+

.. |DHT11_Sc| image:: ../_static/imgs/DHT11_Sc.png
.. |DHT11_Fr| image:: ../_static/imgs/DHT11_Fr.png



Sketch
================================================================

The Raspberry Pi can directly obtain data from the DHT11 sensor through system configuration. Before running the code, it is necessary to configure the Raspberry Pi first.

Configure the config.txt file
----------------------------------------------------------------

Run the command to open the config.txt file.

.. code-block:: console

    $ sudo nano /boot/firmware/config.txt

Add the following line to the end of the file.

.. code-block:: console

    $ dtoverlay=dht11,gpiopin=17

.. image:: ../_static/imgs/java_DHT11_file.png
    :align: center

Press Ctrl+O, Ctrl+X, enter to save and exit the file. And then reboot your Raspberry Pi.

Sketch_DHT11
----------------------------------------------------------------

.. code-block:: console

    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_19_DHT11

.. image:: ../_static/imgs/java_DHT11.png
    :align: center

Enter the command to run the code.

.. code-block:: console

    $ jbang DHT11.java

.. image:: ../_static/imgs/java_DHT11_run.png
    :align: center

When the code is running, the Raspberry Pi will continuously obtain the temperature and humidity data of DHT11 through GPIO17 and print it out. 

Please note that DHT11 is a less sensitive sensor, and sometimes it takes a long time to obtain data, so please be patient.

.. image:: ../_static/imgs/java_DHT11_mes.png
    :align: center

Press Ctrl+C to exit the program.

.. image:: ../_static/imgs/java_DHT11_exit.png
    :align: center

You can run the following command to open the code with Geany to view and edit it.

.. code-block:: console

    $ DHT11.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_DHT11_code.png
    :align: center

If the code fails to run, please check :ref:`Geany Configuration <Geany_Configuration>`.

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_19_DHT11/DHT11.java
    :linenos: 
    :language: java
    :dedent:

Defines the file storage path for temperature and humidity data.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_19_DHT11/DHT11.java
    :linenos: 
    :language: java
    :lines: 6-7
    :dedent:
    
Below are the functions for getting temperature and humidity. The raw data read by the Raspberry Pi from the file needs to be converted to 0.001 times the original value.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_19_DHT11/DHT11.java
    :linenos: 
    :language: java
    :lines: 8-19
    :dedent:

The method to read the contents of a file, loop through each line in the file, and append it to 'content'.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_19_DHT11/DHT11.java
    :linenos: 
    :language: java
    :lines: 21-30
    :dedent:

Create an instance of the DHT11 class, read the temperature and humidity data every 2 seconds, and print it out if the data is normal; if the data is not normal, do not print it. and retrieve the next temperature and humidity data instead.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_19_DHT11/DHT11.java
    :linenos: 
    :language: java
    :lines: 33-51
    :dedent:

Please note that after you finish studying this chapter, you should comment out the line related to DHT11 in the ‘config.txt’ file to avoid errors when Raspberry Pi uses GPIO17 in subsequent chapters.

Run the command to open the config.txt file.

.. code-block:: console

    $ sudo nano /boot/firmware/config.txt
    
Add the “#” in front of the line.

.. code-block:: console

    $ #dtoverlay=dht11,gpiopin=17

.. image:: ../_static/imgs/java_DHT11_txt.png
    :align: center

Save the file and reboot your Raspberry Pi.