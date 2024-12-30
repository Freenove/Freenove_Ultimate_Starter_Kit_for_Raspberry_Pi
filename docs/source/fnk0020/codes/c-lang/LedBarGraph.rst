##############################################################################
Chapter LED Bar Graph
##############################################################################


We have learned how to control one LED to blink. Next, we will learn how to control a number of LEDs

Project Flowing Water Light
****************************************************************

In this project, we use a number of LEDs to make a flowing water light.

Component List
================================================================

+--------------------------------------------------+---------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                 |                                                   |
|                                                  | Jumper Wires x6                                   |
|2. GPIO Extension Board & Ribbon Cable x1         |                                                   |
|                                                  |  |jumper-wire|                                    |
|3. Breadboard x1                                  |                                                   |
+--------------------------------------------------+---------------------------------------------------+
|  Bar Graph LED x1                                | Resistor 220Ω x10                                 |
|                                                  |                                                   |
|   |LED-BAR|                                      |  |res-220R-hori|                                  |
+--------------------------------------------------+---------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
.. |LED-BAR| image:: ../_static/imgs/LED-BAR.png
    :width: 60%
.. |res-220R-hori| image:: ../_static/imgs/res-220R-hori.png
    :width: 60%

Component knowledge
================================================================
Let us learn about the basic features of these components to use and understand them better.

Bar Graph LED
----------------------------------------------------------------
A Bar Graph LED has 10 LEDs integrated into one compact component. The two rows of pins at its bottom are paired to identify each LED like the single LED used earlier. 

.. image:: ../_static/imgs/LED_BAR_NUM.png
        :align: center

Circuit
================================================================
A reference system of labels is used in the circuit diagram below. Pins with the same network label are connected together.

Schematic diagram             

.. image:: ../_static/imgs/LED-Graph-Sch.png                                                                
        :width: 100% 
                   

Hardware connection. If you need any support, please feel free to contact us via: support@freenove.com

.. image:: ../_static/imgs/LED-Graph-Fritzing.png                                                                
        :width: 100%   

.. note:: 
        :red:`If LEDbar doesn't work, rotate LEDbar 180° to try. The label is random.`

.. note:: 
        **Youtube video:** https://youtu.be/3rh-b05VoiU

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/3rh-b05VoiU" frameborder="0" allowfullscreen></iframe>

In this circuit, the cathodes of the LEDs are connected to the GPIO, which is different from the previous circuit. The LEDs turn ON when the GPIO output is low level in the program. 


Code
================================================================
This project is designed to make a flowing water lamp, which are these actions: First turn LED #1 ON, then turn it OFF. Then turn LED #2 ON, and then turn it OFF... and repeat the same to all 10 LEDs until the last LED is turns OFF. This process is repeated to achieve the “movements” of flowing water.

C Code 3.1.1 LightWater
----------------------------------------------------------------

First, observe the project result, and then learn about the code in detail.

.. hint:: 
        :red:`If you have any concerns, please contact us via:` support@freenove.com

1. Use ``cd`` command to enter ``03.1.1_LightWater`` directory of C code.

.. code-block:: console

       $ cd ~/Freenove_Kit/Code/C_Code/03.1.1_LightWater

2. Use the following command to compile ``LightWater.c`` and generate executable file ``LightWater``.

.. code-block:: console

       $ gcc LightWater.c -o LightWater -lwiringPi

3. Then run the generated file “LightWater”.

.. code-block:: console

       $ sudo ./LightWater

After the program is executed, you will see that Bar Graph LED starts with the flowing water pattern flashing from left to right and then back from right to left.

The following is the program code:

.. literalinclude:: ../../../freenove_Kit/Code/C_Code/03.1.1_LightWater/LightWater.c
    :linenos: 
    :language: C

In the program, configure the GPIO0-GPIO9 to output mode. Then, in the endless “while” loop of main function, use two “for” loop to realize flowing water light from left to right and from right to left.

.. literalinclude:: ../../../freenove_Kit/Code/C_Code/03.1.1_LightWater/LightWater.c
    :linenos: 
    :language: C
