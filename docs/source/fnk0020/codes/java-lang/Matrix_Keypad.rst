##############################################################################
Chapter Matrix Keypad
##############################################################################


Earlier we learned about a single Push Button Switch. In this chapter, we will learn about Matrix Keyboards, which integrates a number of Push Button Switches as Keys for the purposes of Input.

Project Matrix Keypad
****************************************************************

In this project, we will attempt to get every key code on the Matrix Keypad to work.

Component List
================================================================

+-------------------------------------------------+-------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |                                                 |     
|                                                 |                                                 |       
|2. GPIO Extension Board & Ribbon Cable x1        |                                                 |       
|                                                 |                                                 |                                                            
|3. Breadboard x1                                 |   4x4 Matrix Keypad x1                          |                                                                 
+-------------------------------------------------+                                                 |
| Jumper wire                                     |     |Keypad|                                    |
|                                                 |                                                 |
|  |jumper-wire|                                  |                                                 |
+-------------------------------------------------+                                                 |
| Resistor 10kΩ x4                                |                                                 |
|                                                 |                                                 |
|  |Resistor-10kΩ|                                |                                                 |
+-------------------------------------------------+-------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
    :width: 50%
.. |Resistor-10kΩ| image:: ../_static/imgs/Resistor-10kΩ.png
    :width: 5%
.. |Keypad| image:: ../_static/imgs/Keypad.png
    :width: 200%


Component knowledge
================================================================

4x4 Matrix Keypad
----------------------------------------------------------------

A Keypad Matrix is a device that integrates a number of keys in one package. As is shown below, a 4x4 Keypad Matrix integrates 16 keys (think of this as 16 Push Button Switches in one module):

.. image:: ../_static/imgs/Keypad_1.png
    :align: center

Similar to the integration of an LED Matrix, the 4x4 Keypad Matrix has each row of keys connected with one pin and this is the same for the columns. Such efficient connections reduce the number of processor ports required. The internal circuit of the Keypad Matrix is shown below.

.. image:: ../_static/imgs/Keypad_2.png
    :align: center

The method of usage is similar to the Matrix LED, by using a row or column scanning method to detect the state of each key's position by column and row. Take column scanning method as an example, send low level to the first 1 column (Pin1), detect level state of row 5, 6, 7, 8 to judge whether the key A, B, C, D are pressed. Then send low level to column 2, 3, 4 in turn to detect whether other keys are pressed. Therefore, you can get the state of all of the keys.

Circuit
================================================================

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |Keypad_Sc|                                                                                  |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         |
|                                                                                                |
|   |Keypad_Fr|                                                                                  | 
+------------------------------------------------------------------------------------------------+

.. |Keypad_Sc| image:: ../_static/imgs/Keypad_Sc.png
.. |Keypad_Fr| image:: ../_static/imgs/Keypad_Fr.png


Sketch
================================================================

In this chapter, we will learn to use a martrix keypad.

Sketch_MatrixKeypad
----------------------------------------------------------------

First, enter where the project is located:

.. code-block:: console

    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_20_MatrixKeypad

.. image:: ../_static/imgs/java_pad.png
    :align: center

Enter the command to run the code.

.. code-block:: console

    $ jbang MatrixKeypad.java

.. image:: ../_static/imgs/java_pad_run.png
    :align: center

When the code is running, press any key on the keypad and the corresponding value will be printed on the terminal.

.. image:: ../_static/imgs/java20_00.png
    :align: center

Press Ctrl+C to exit the program.

.. image:: ../_static/imgs/java_pad_exit.png
    :align: center

You can run the following command to open the code with Geany to view and edit it.

.. code-block:: console

    $ geany MatrixKeypad.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_pad_code.png
    :align: center

If the code fails to run, please check :ref:`Geany Configuration <Geany_Configuration>`.

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_20_MatrixKeypad/MatrixKeypad.java
    :linenos: 
    :language: java
    :dedent:

Re-encapsulate the GPIO functions using the Pi4J library, with these functions referring to the classic usage of Arduino. This is done to ensure compatibility with the later Key class and Keypad class, making matrix buttons easier to use. If you are interested in this code, please review it, as we will include detailed comments within the code.

.. code-block:: c
    :linenos:

    class GPIO {
      ... ...
    }

    //class Key:Define some of the properties of Key
    class Key {
      ... ...
    }

    class Keypad {
      ... ...
    }

Define the key values corresponding to the matrix keyboard.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_20_MatrixKeypad/MatrixKeypad.java
    :linenos: 
    :language: java
    :lines: 413-418
    :dedent:

Define pin numbers for the row and column the matrix keyboard.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_20_MatrixKeypad/MatrixKeypad.java
    :linenos: 
    :language: java
    :lines: 420-423
    :dedent:

Add a shutdown hook to ensure the Pi4J context is closed properly.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_20_MatrixKeypad/MatrixKeypad.java
    :linenos: 
    :language: java
    :lines: 439-444
    :dedent:

The key value is read from the matrix keyboard every 10 milliseconds. If the key value is not detected as empty, it is printed on the terminal interface.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_20_MatrixKeypad/MatrixKeypad.java
    :linenos: 
    :language: java
    :lines: 448-457
    :dedent: