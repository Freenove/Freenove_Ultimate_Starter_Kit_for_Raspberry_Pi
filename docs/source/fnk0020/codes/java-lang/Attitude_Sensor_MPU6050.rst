##############################################################################
Chapter Attitude Sensor MPU6050
##############################################################################


In this chapter, we will learn about a MPU6050 Attitude sensor, which integrates an Accelerometer and Gyroscope.

Project Read a MPU6050 Sensor Module
****************************************************************

In this project, we will read Acceleration and Gyroscope Data of the MPU6050 Sensor.

Component List
================================================================

+-------------------------------------------------+-------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |                                                 |     
|                                                 | Jumper Wires x4                                 |       
|2. GPIO Extension Board & Ribbon Cable x1        |                                                 |       
|                                                 |  |jumper-wire|                                  |                                                            
|3. Breadboard x1                                 |                                                 |                                                                 
+-------------------------------------------------+-------------------------------------------------+
| MPU6050                                                                                           |     
|                                                                                                   |       
|  |MPU6050|                                                                                        |       
+---------------------------------------------------------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
.. |MPU6050| image:: ../_static/imgs/MPU6050.png

Component knowledge
================================================================

MPU6050
----------------------------------------------------------------

MPU6050 Sensor Module is a complete 6-axis Motion Tracking Device. It combines a 3-axis Gyroscope, a 3-axis Accelerometer and a DMP (Digital Motion Processor) all in a small package. The settings of the Accelerometer and Gyroscope of MPU6050 can be changed. A precision wide range digital temperature sensor is also integrated to compensate data readings for changes in temperature, and temperature values can also be read. The MPU6050 Module follows the I2C communication protocol and the default address is 0x68.

.. image:: ../_static/imgs/MPU6050_1.png
    :width: 80%
    :align: center

The port description of the MPU6050 Module is as follows:


.. list-table::
   :align: center
   :header-rows: 1
   :class: product-table

   * - Pin name
     - Pin number
     - Description

   * - VCC
     - 1
     - Positive pole of power supply with voltage 5V

   * - GND
     - 2
     - Negative pole of power supply
    
   * - SCL
     - 3
     - I2C communication clock pin
     
   * - SDA
     - 4
     - I2C communication data pin

   * - XDA
     - 5
     - I2C host data pin which can be connected to other devices.

   * - XCL
     - 6
     - I2C host clock pin which can be connected to other devices.

   * - AD0
     - 7
     - I2C address bit control pin. 

       **Low level:** the device address is 0x68 

       **High level:** the device address is 0x69

   * - INT
     - 8
     - Output interrupt pin

For more detail, please refer to the MPU6050 datasheet.

MPU6050 is widely used to assist with balancing vehicles, robots and aircraft, mobile phones and other products which require stability to control stability and attitude or which need to sense same.

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |MPU6050_Sc|                                                                                 |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         | 
|                                                                                                |
|   |MPU6050_Fr|                                                                                 |
+------------------------------------------------------------------------------------------------+

.. |MPU6050_Sc| image:: ../_static/imgs/MPU6050_Sc.png
.. |MPU6050_Fr| image:: ../_static/imgs/MPU6050_Fr.png

Sketch
================================================================

In this chapter, we will learn to obtain MPU6050 data and print them.

Sketch_23_MPU6050
----------------------------------------------------------------

First, enter where the project is located:

.. code-block:: console

    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050

.. image:: ../_static/imgs/java_mpu6050.png
    :align: center

Enter the command to run the code.

.. code-block:: console

    $ jbang MPU6050RAW.java

.. image:: ../_static/imgs/java_mpu6050_run.png
    :align: center

When the code is running, pick up the entire board with and make any movements such as shaking it left and right, turning it upside down, etc. You can observe the changes in data on the terminal interface.

.. image:: ../_static/imgs/java_mpu6050_mes.png
    :align: center

Press Ctrl+C to exit the program.

You can run the following command to open the code with Geany to view and edit it.

.. code-block:: console

    $ geany MPU6050RAW.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_mpu6050_code.png
    :align: center

If the code fails to run, please check :doc:`Geany Configuration`.

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java

Define the commonly used registers of MPU6050.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 28-36

Initialize the I2C interface of the Raspberry Pi.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 63-69

Configure MPU6050 so that it can work properly.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 89-95

Get the I2C address of MPU6050. This is only used for testing.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 98-102

Get raw acceleration data.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 105-113

Get raw gyroscope data.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 116-124

Define the I2C address of MPU6050.

.. code-block:: python

    public static final int MPU6050_ADDRESS = 0x68;  

Get the I2C address from the MPU6050 register and determine whether it is consistent with the predefined address.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 145-152

Get the raw data of the accelerometer and gyroscope of MPU6050, convert them and print them out.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_23_MPU6050/MPU6050RAW.java
    :linenos: 
    :language: java
    :lines: 154-163

Thread exception capture ensures that the code runs normally.

.. code-block:: c

    catch (InterruptedException e) {  
        e.printStackTrace();  
        Thread.currentThread().interrupt();  
    }

When terminating the execution of the code, shut down the MPU6050 device and disable the I2C functionality on the Raspberry Pi.

.. code-block:: c

    finally {  
        if (mpu != null) {  
            mpu.close();  
        }  
    }  

