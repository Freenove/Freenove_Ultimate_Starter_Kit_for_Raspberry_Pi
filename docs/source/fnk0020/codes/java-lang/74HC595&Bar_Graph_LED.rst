##############################################################################
Chapter 74HC595 & Bar Graph LED
##############################################################################


We have used LED Bar Graph to make a flowing water light, in which 10 GPIO ports of RPi are occupied. More GPIO ports mean that more peripherals can be connected to RPi, so GPIO resource is very precious. Can we make flowing water light with less GPIO ports? In this chapter, we will learn a component, 74HC595, which can achieve the target.

Project FollowLight
****************************************************************

Now let us learn how to use the 74HC595 IC Chip to make a flowing water light using less GPIO.

Component List
================================================================

+-------------------------------------------------+-------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |                                                 |     
|                                                 |   Jumper Wires x17                              |       
|2. GPIO Extension Board & Ribbon Cable x1        |                                                 |       
|                                                 |     |jumper-wire|                               |                                                            
|3. Breadboard x1                                 |                                                 |                                                                 
+-----------------------------+-------------------+--------------+----------------------------------+
| 74HC595 x1                  | Bar Graph LED x1                 | Resistor 220Ω x8                 |
|                             |                                  |                                  |
|  |74HC595|                  |  |LED-BAR|                       |  |res-220R|                      |
+-----------------------------+----------------------------------+----------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
.. |74HC595| image:: ../_static/imgs/74HC595.png
    :width: 20%
.. |LED-BAR| image:: ../_static/imgs/LED-BAR.png
    :width: 100%
.. |res-220R| image:: ../_static/imgs/res-220R.png
    :width: 15%

Component knowledge
================================================================

A 74HC595 chip is used to convert serial data into parallel data. A 74HC595 chip can convert the serial data of one byte into 8 bits, and send its corresponding level to each of the 8 ports correspondingly. With this characteristic, the 74HC595 chip can be used to expand the IO ports of a Raspberry Pi. At least 3 ports on the RPI board are required to control the 8 ports of the 74HC595 chip.

.. image:: ../_static/imgs/74HC595-1.png
    :align: center

The ports of the 74HC595 chip are described as follows:

+----------+--------------+---------------------------------------------------------------------------+
| Pin name | Pin number   |                    Description                                            |   
+==========+==============+===========================================================================+
| Q0-Q7    | 15, 1-7      | Parallel Data Output                                                      |                   
+----------+--------------+---------------------------------------------------------------------------+                                                  
| VCC      | 16           | The Positive Electrode of the Power Supply, the Voltage is 2~6V           |
+----------+--------------+---------------------------------------------------------------------------+  
| GND      | 8            | The Negative Electrode of Power Supply                                    |
+----------+--------------+---------------------------------------------------------------------------+  
| DS       | 14           | Serial Data Input                                                         |                                      
+----------+--------------+---------------------------------------------------------------------------+
|          |              | Enable Output,                                                            |
|          |              |                                                                           |
| OE       | 13           | When this pin is in high level, Q0-Q7 is in high resistance state         |  
|          |              |                                                                           |  
|          |              | When this pin is in low level, Q0-Q7 is in output mode                    |                                       
+----------+--------------+---------------------------------------------------------------------------+                                                   
|          |              | Parallel Update Output: when its electrical level is rising,              | 
| ST_CP    | 12           |                                                                           |  
|          |              | it will update the parallel data output.                                  |                                      
+----------+--------------+---------------------------------------------------------------------------+
|          |              | Serial Shift Clock: when its electrical level is rising,                  |
| SH_CP    | 11           |                                                                           |
|          |              | it will update the parallel data output.                                  | 
+----------+--------------+---------------------------------------------------------------------------+
|          |              | Remove Shift Register: When this pin is in low level,                     | 
| MR       | 10           |                                                                           |
|          |              | the content in shift register will be cleared.                            | 
+----------+--------------+---------------------------------------------------------------------------+                                                  
|  Q7      | 9            | Serial Data Output: it can be connected to more 74HC595 chips in series.  |                                   
+----------+--------------+---------------------------------------------------------------------------+ 

.. seealso::

    For more details, please refer to the datasheet on the 74HC595 chip.

Circuit
================================================================

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |74HC595-Sc|                                                                                 |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         |
|                                                                                                |
|   |74HC595-Fr|                                                                                 | 
+------------------------------------------------------------------------------------------------+

.. |74HC595-Sc| image:: ../_static/imgs/74HC595-Sc.png
.. |74HC595-Fr| image:: ../_static/imgs/74HC595-Fr.png


Sketch
================================================================

In this chapter, we will learn how to drive the LED Bar by expanding the chip.

Sketch_15_FlowingLight02
----------------------------------------------------------------

First, enter where the project is located:

.. code-block:: console
    
    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02

.. image:: ../_static/imgs/java_Barled.png
    :align: center

Enter the command to run the code.

.. code-block:: console
    
    $ jbang FlowingLight02.java

.. image:: ../_static/imgs/java_Barled_run.png
    :align: center

When the code is running, you can see the LEDs of the LED bar light up in a flowing water pattern.

Press Ctrl+C to exit the program.

.. image:: ../_static/imgs/java_Barled_exit.png
    :align: center

You can run the following command to open the code with Geany to view and edit it.

.. code-block:: console
    
    $ geany FlowingLight02.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_Barled_code.png
    :align: center

If the code fails to run, please check :doc:`Geany Configuration`.

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java

Define the data transfer order for enumeration types.

.. code-block:: python

    public enum Order {LSBFIRST, MSBFIRST};  

Define the data pin, latch pin, clock pin, and Pi4j context.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 15-18

Constructor, initialize pins and context.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 20-25

Delay function in microsecond.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 27-32

Shift function for expansion chip. The Raspberry Pi sends data to the extended chip through GPIO.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 34-53

Update the expansion chip latch to let the expansion chip output the signal. Usually you need to first call the shiftOut function to input data to the expansion chip, and then call the updateLatch function to have the expansion chip output the signal level corresponding to the data.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 55-59

When Pi4j context is not used, shut it down to release resources.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 61-63

Define the pin number of the driver expansion chip.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 67-69

Create a pi4j automatic context and create an HC595 instance.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 72-73

The Raspberry Pi controls the LED bar to flow from left to right and then from right to left.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 77-95

Shutdown HC595 instance resources.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_15_FlowingLight02/FlowingLight02.java
    :linenos: 
    :language: java
    :lines: 96-98
