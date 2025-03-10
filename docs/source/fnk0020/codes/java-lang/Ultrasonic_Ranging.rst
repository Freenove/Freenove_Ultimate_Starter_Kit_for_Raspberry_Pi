##############################################################################
Chapter Ultrasonic Ranging
##############################################################################

In this chapter, we learn a module which use ultrasonic to measure distance.

Project Ultrasonic Ranging
****************************************************************

In this project, we use ultrasonic ranging module to measure distance, and print out the data in the terminal.

Component List
================================================================

+-------------------------------------------------+-------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |                                                 |     
|                                                 | Jumper Wires x4                                 |       
|2. GPIO Extension Board & Ribbon Cable x1        |                                                 |       
|                                                 |  |jumper-wire|                                  |                                                            
|3. Breadboard x1                                 |                                                 |                                                                 
+-------------------------------------------------+-------------------------------------------------+
| Ultrasonic Module x1                            | Resistor 1kΩ x3                                 |     
|                                                 |                                                 |       
|  |Ultrasonic_Module|                            |  |res-1K-hori|                                  |       
+-------------------------------------------------+-------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
.. |Ultrasonic_Module| image:: ../_static/imgs/Ultrasonic_Module.png
.. |res-1K-hori| image:: ../_static/imgs/res-1K-hori.png
    :width: 60%

Component Knowledge
================================================================

The Ultrasonic Ranging Module uses the principle that ultrasonic waves will be reflected when they encounter any obstacles. This is possible by counting the time interval between when the ultrasonic wave is transmitted to when the ultrasonic wave reflects back after encountering an obstacle. Time interval counting will end after an ultrasonic wave is received, and the time difference (delta) is the total time of the ultrasonic wave’s journey from being transmitted to being received. Because the speed of sound in air is a constant, and is about v=340m/s, we can calculate the distance between the Ultrasonic Ranging Module and the obstacle: s=vt/2.

.. image:: ../_static/imgs/Ultrasonic_knowledge.png
    :align: center

.. math:: 2S=V·t.

The Ultrasonic Ranging Module integrates a both an ultrasonic transmitter and a receiver. The transmitter is used to convert electrical signals (electrical energy) into high frequency (beyond human hearing) sound waves (mechanical energy) and the function of the receiver is opposite of this. The picture and the diagram of the Ultrasonic Ranging Module are shown below:

.. list-table::
   :widths: 50 50
   :align: center

   * - |Ultrasonic_Module|
     - |HC_SR04|

.. |HC_SR04| image:: ../_static/imgs/HC_SR04.png

Pin description:

.. list-table::
   :widths: 50 50
   :align: center

   * - VCC
     - power supply pin

   * - Trig
     - trigger pin

   * - Echo
     - Echo pin
    
   * - GND
     - GND

Technical specs:

.. list-table::
   :widths: 50 50
   :align: center

   * - Working voltage: 5V 
     - Working current: 12mA

   * - Minimum measured distance: 2cm
     - Maximum measured distance: 200cm

Instructions for Use: output a high-level pulse in Trig pin lasting for least 10uS, the module begins to transmit ultrasonic waves. At the same time, the Echo pin is pulled up. When the module receives the returned ultrasonic waves from encountering an obstacle, the Echo pin will be pulled down. The duration of high level in the Echo pin is the total time of the ultrasonic wave from transmitting to receiving, s=vt/2. This is done constantly.

.. image:: ../_static/imgs/signal.png
    :align: center

Circuit
================================================================

Note that the voltage of ultrasonic module is 5V in this circuit.

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |Ultrasonic_Sc|                                                                              |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         | 
|                                                                                                |
|   |Ultrasonic_Fr|                                                                              |
+------------------------------------------------------------------------------------------------+

.. |Ultrasonic_Sc| image:: ../_static/imgs/Ultrasonic_Sc.png
.. |Ultrasonic_Fr| image:: ../_static/imgs/Ultrasonic_Fr.png

Sketch
================================================================

In this chapter, we will learn the usage of the ultrasonic sensor.

Sketch_22_UltrasonicRanging
----------------------------------------------------------------

First, enter where the project is located:

.. code-block:: console

    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_22_UltrasonicRanging

.. image:: ../_static/imgs/java_ultrasonic.png
    :align: center

Enter the command to run the code.

.. code-block:: console

    $ jbang UltrasonicRanging.java

.. image:: ../_static/imgs/java_ultrasonic_run.png
    :align: center

After running the code, the Raspberry Pi will continue to obtain the distance values of the ultrasonic module and print them on the terminal interface

.. image:: ../_static/imgs/java_ultrasonic_mes.png
    :align: center

Press Ctrl+C to exit the program.

.. image:: ../_static/imgs/java_ultrasonic_exit.png
    :align: center

You can run the following command to open the code with Geany to view and edit it.

.. code-block:: console

    $ geany UltrasonicRanging.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_ultrasonic_code.png
    :align: center

If the code fails to run, please check :ref:`Geany Configuration <Geany_Configuration>`.

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_22_UltrasonicRanging/UltrasonicRanging.java
    :linenos: 
    :language: java
    :dedent:

Re-encapsulate the GPIO functions using the Pi4J library, with these functions emulating the classic usage patterns of Arduino. This is done to ensure compatibility with the upcoming Ultrasonic class, allowing the Raspberry Pi to easily obtain distance data from ultrasonic modules. If you are interested in this code, please review it, as we will include detailed comments within the code.

.. code-block:: c

    class GPIO {  
      ... ...
    }  
    
    class Ultrasonic {  
      ... ...
    } 

Initialize the Pi4J context and assign it to GPIO.pi4.

Initialize the Ultrasonic class and associate it with GPIO14 and GPIO15.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_22_UltrasonicRanging/UltrasonicRanging.java
    :linenos: 
    :language: java
    :lines: 178-181
    :dedent:

Obtain the ultrasonic distance data every 100 milliseconds and display them on the terminal interface.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_22_UltrasonicRanging/UltrasonicRanging.java
    :linenos: 
    :language: java
    :lines: 183-191
    :dedent:

At the end of the code, release the resources.

.. code-block:: c
    :linenos:

     finally {  
        if (GPIO.pi4j != null) {  
            GPIO.pi4j.shutdown();  
        }  
    }  
