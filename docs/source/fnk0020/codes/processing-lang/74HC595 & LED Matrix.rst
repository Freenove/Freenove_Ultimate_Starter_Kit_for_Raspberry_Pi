################################################################
Chapter 74HC595 & LED Matrix
################################################################

Thus far we have learned how to use the 74HC595 IC Chip to control the Bar Graph LED and the 7-Segment Display. We will now use 74HC595 IC Chips to control an LED Matrix.

Project LED Matrix
****************************************************************

In this project, we will use two 74HC595 IC chips to control a monochrome (one color) (8X8) LED Matrix to make it display both simple graphics and characters.

Component List
================================================================

+-------------------------------------------------+-------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |                                                 |     
|                                                 |   Jumper Wires x36                              |       
|2. GPIO Extension Board & Ribbon Cable x1        |                                                 |       
|                                                 |     |jumper-wire|                               |                                                            
|3. Breadboard x1                                 |                                                 |                                                                 
+-----------------------------+-------------------+--------------+----------------------------------+
| 74HC595 x2                  | 8x8 LEDMatrix x1                 | Resistor 220Ω x8                 |
|                             |                                  |                                  |
|  |74HC595|                  |  |LED_Matrix|                    |  |res-220R|                      |
+-----------------------------+----------------------------------+----------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
.. |74HC595| image:: ../_static/imgs/74HC595.png
    :width: 40%
.. |7_Segment_Display| image:: ../_static/imgs/7_Segment_Display.png
    :width: 100%
.. |res-220R| image:: ../_static/imgs/res-220R.png
    :width: 20%
.. |LED_Matrix| image:: ../_static/imgs/LED_Matrix.png

Component knowledge
================================================================

LED matrix
----------------------------------------------------------------

An LED Matrix is a rectangular display module that consists of a uniform grid of LEDs. The following is an 8X8 monochrome (one color) LED Matrix containing 64 LEDs (8 rows by 8 columns).

.. image:: ../_static/imgs/LED_Matrix_1.png
    :align: center
    :width: 50%

In order to facilitate the operation and reduce the number of ports required to drive this component, the Positive Poles of the LEDs in each row and Negative Poles of the LEDs in each column are respectively connected together inside the LED Matrix module, which is called a Common Anode. There is another arrangement type. Negative Poles of the LEDs in each row and the Positive Poles of the LEDs in each column are respectively connected together, which is called a Common Cathode.

The LED Matrix that we use in this project is a Common Anode LED Matrix.

.. image:: ../_static/imgs/LED_Matrix_2.png
    :align: center

Here is how a Common Anode LED Matrix works. First, choose 16 ports on RPI board to connect to the 16 ports of LED Matrix. Configure one port in columns for low level, which makes that column the selected port. Then configure the eight port in the row to display content in the selected column. Add a delay value and then select the next column that outputs the corresponding content. This kind of operation by column is called Scan. If you want to display the following image of a smiling face, you can display it in 8 columns, and each column is represented by one byte.

.. image:: ../_static/imgs/LED_Matrix_3.png
    :align: center

To begin, display the first column, then turn off the first column and display the second column. (and so on) .... turn off the seventh column and display the 8th column, and then start the process over from the first column again like the control of LED Bar Graph project. The whole process will be repeated rapidly in a loop. Due to the principle of optical afterglow effect and the vision persistence effect in human sight, we will see a picture of a smiling face directly rather than individual columns of LEDs turned ON one column at a time (although in fact this is the reality we cannot perceive). 

Scanning rows is another option to display on an LED Matrix (dot matrix grid). Whether scanning by row or column, 16 GPIO is required. In order to save GPIO ports of control board, two 74HC595 IC Chips are used in the circuit. Every 74HC595 IC Chip has eight parallel output ports, so two of these have a combined total of 16 ports, which is just enough for our project. The control lines and data lines of the two 74HC595 IC Chips are not all connected to the RPi, but connect to the Q7 pin of first stage 74HC595 IC Chip and to the data pin of second IC Chip. The two 74HC595 IC Chips are connected in series, which is the same as using one "74HC595 IC Chip" with 16 parallel output ports.

Circuit
================================================================

In circuit of this project, the power pin of the 74HC595 IC Chip is connected to 3.3V. It can also be connected to 5V to make LED Matrix brighter.

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |LED_MAtrix_Sc|                                                                              |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         |
|                                                                                                |
|   |LED_MAtrix_Fr|                                                                              | 
+------------------------------------------------------------------------------------------------+

.. |LED_MAtrix_Sc| image:: ../_static/imgs/LED_MAtrix_Sc.png
.. |LED_MAtrix_Fr| image:: ../_static/imgs/LED_MAtrix_Fr.png
    
Sketch
================================================================

Sketch 12.1.1 LEDMatrix
----------------------------------------------------------------

First observe the result after running the sketch, and then learn about the code in detail.

1.	Use Processing to open the file Sketch_12_1_1_LEDMatrix.

.. code-block:: console    
    
    $ processing ~/Freenove_Kit/Processing/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde

2.	Click on "RUN" to run the code.

After the program is executed, LEDMatrix will show a pattern of a smiling face, then start scrolling display of character "0-F". Display Window will display the characters "0-F" synchronously. Dragging the progress bar can change the rolling speed of character on LEDMatrix. (The project code in the LEDMatrix is operated with scanning method in a separate thread. The uncertainty of the CPU time slice may cause LEDMatrix display flashing.)

.. image:: ../_static/imgs/LEDMatrix.png
    :align: center

This project contains a lot of code files, and the core code is contained in the file Sketch_12_1_1_LEDMatrix. The other files only contain some custom classes.

.. image:: ../_static/imgs/LEDMatrix_code.png
    :align: center

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Code/Processing_Code/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde
    :linenos: 
    :language: c

In the code, first define the data of the smiling face and characters "0-F".

.. literalinclude:: ../../../freenove_Kit/Code/Processing_Code/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde
    :linenos: 
    :language: c
    :lines: 17-39

Then create a new thread t. LEDMatrix scan display code will be executed in run() of this thread.

.. literalinclude:: ../../../freenove_Kit/Code/Processing_Code/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde
    :linenos: 
    :language: c
    :lines: 40-63

The function setup(), defines size of Display Window, ProgressBar class objects and IC75HC595 class object, and starts the thread t.

.. literalinclude:: ../../../freenove_Kit/Code/Processing_Code/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde
    :linenos: 
    :language: c
    :lines: 41-47

In draw(), draw the relevant information and the current number to display.

.. literalinclude:: ../../../freenove_Kit/Code/Processing_Code/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde
    :linenos: 
    :language: c
    :lines: 49-63

Subfunction showMatrix () makes LEDMatrix display a smiling face pattern, which lasts for a period of time.

.. literalinclude:: ../../../freenove_Kit/Code/Processing_Code/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde
    :linenos: 
    :language: c
    :lines: 64-75

Subfunction showNum() makes LEDMatrix scroll displaying character "0-F", in which the variable k is used to adjust the scrolling speed.

.. literalinclude:: ../../../freenove_Kit/Code/Processing_Code/Sketches/Sketch_12_1_1_LEDMatrix/Sketch_12_1_1_LEDMatrix.pde
    :linenos: 
    :language: c
    :lines: 76-90

If you have more interests in LED matrix, you can download an interesting app to explore.

https://play.google.com/store/apps/details?id=com.vitogusmano.arduinoledmatrixanimator

If you have any concerns about the app, please contact with Vito Gusmano (vigus9000@gmail.com).
