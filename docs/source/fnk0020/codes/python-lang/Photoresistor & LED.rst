################################################################
Chapter Photoresistor & LED
################################################################


In this chapter, we will learn how to use a photoresistor to make an automatic dimming nightlight.

Project NightLamp
****************************************************************

A Photoresistor is very sensitive to the amount of light present. We can take advantage of the characteristic to make a nightlight with the following function. When the ambient light is less (darker environment), the LED will automatically become brighter to compensate and when the ambient light is greater (brighter environment) the LED will automatically dim to compensate.


Component List
================================================================

+-------------------------------------------------+-------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |   Resistor 220Ω x1            |     
|                                                 |                               |       
|2. GPIO Extension Board & Ribbon Cable x1        |   |res-220R|                  |       
|                                                 |                               |                                                            
|3. Breadboard x1                                 |                               |                                                                 
+-------------------------------------------------+-------------------------------+
| Photoresistor x1                                |   Resistor 10kΩ x3            |
|                                                 |                               |
| |Phtotresistor|                                 |  |Resistor-10kΩ|              |                           
+-------------------------------------------------+-------------------------------+
| ADC module x1 (Only one)                        |   LED x1                      |
|                                                 |                               |
| |ADC-module-1|   :xx-large:`or`  |ADC-module-2| |   |red-led|                   |                   
|                                                 |                               |  
+-------------------------------------------------+-------------------------------+
|   Jumper Wire M/M x17                                                           |
|                                                                                 | 
|      |jumper-wire|                                                              |
+---------------------------------------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
        :width: 80%
.. |Resistor-10kΩ| image:: ../_static/imgs/Resistor-10kΩ.png
        :width: 15%
.. |res-220R| image:: ../_static/imgs/res-220R.png
        :width: 15%
.. |Phtotresistor| image:: ../_static/imgs/Phtotresistor.png
        :width: 15%
.. |ADC-module-1| image:: ../_static/imgs/ADC-module-1.png
.. |ADC-module-2| image:: ../_static/imgs/ADC-module-2.png
.. |red-led| image:: ../_static/imgs/red-led.png
        :width: 40%

Component knowledge
================================================================

Photoresistor
----------------------------------------------------------------

A Photoresistor is simply a light sensitive resistor. It is an active component that decreases resistance with respect to receiving luminosity (light) on the component's light sensitive surface. A Photoresistor's resistance value will change in proportion to the ambient light detected. With this characteristic, we can use a Photoresistor to detect light intensity. The Photoresistor and its electronic symbol are as follows.

.. image:: ../_static/imgs/Phtotresistor-2.png
        :width: 50%
        :align: center

The circuit below is used to detect the change of a Photoresistor's resistance value:

.. image:: ../_static/imgs/up.png
        :width: 20%

.. image:: ../_static/imgs/down.png
        :width: 20%

In the above circuit, when a Photoresistor's resistance vale changes due to a change in light intensity, the voltage between the Photoresistor and Resistor R1 will also change. Therefore, the intensity of the light can be obtained by measuring this voltage.

Circuit with ADS7830
================================================================

The circuit used is similar to the Soft light project. The only difference is that the input signal of the AIN0 pin of ADC changes from a Potentiometer to a combination of a Photoresistor and a Resistor.

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |ADS7830-Schematic-4|                                                                        |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         |
|                                                                                                |
|   |ADS7830-fritizing-5|                                                                        |
|                                                                                                |
|    **Video:** https://youtu.be/r6p3zhXsyko                                                     |
+------------------------------------------------------------------------------------------------+

.. |ADS7830-Schematic-4| image:: ../_static/imgs/ADS7830-Schematic-4.png
.. |ADS7830-fritizing-5| image:: ../_static/imgs/ADS7830-fritizing-5.png

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/r6p3zhXsyko" frameborder="0" allowfullscreen></iframe>

Circuit with PCF8591
================================================================

The circuit used is similar to the Soft light project. The only difference is that the input signal of the AIN0 pin of ADC changes from a Potentiometer to a combination of a Photoresistor and a Resistor.

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |PCF8591-Schematic-4|                                                                        |
+------------------------------------------------------------------------------------------------+
|   Hardware connection.                                                                         |
|                                                                                                |
|   |PCF8591-fritizing-4|                                                                        |
+------------------------------------------------------------------------------------------------+

.. |PCF8591-Schematic-4| image:: ../_static/imgs/PCF8591-Schematic-4.png
.. |PCF8591-fritizing-4| image:: ../_static/imgs/PCF8591-fritizing-4.png

Code
================================================================

The code used in this project is identical with what was used in the last chapter.

Python Code 10.1.1 Nightlamp
----------------------------------------------------------------

If you did not configure I2C, please refer to :doc:`Chapter 7 ADC <ADC>`. If you did, please continue.

First, observe the project result, and then learn about the code in detail. 

.. hint:: 
    :red:`If you have any concerns, please contact us via:` support@freenove.com

1.	Use cd command to enter 10.1_Nightlamp directory of Python code.

.. code-block:: console

    $ cd ~/Freenove_Kit/Code/Python_GPIOZero_Code/10.1.1_Nightlamp

2.	Use the python command to execute the Python code “Nightlamp.py”.

.. code-block:: console

    $ python Nightlamp.py

After the program is executed, if you cover the Photoresistor or increase the light shining on it, the brightness of the LED changes accordingly. As in previous projects the Terminal window will display the current input voltage value of ADC module A0 pin and the converted digital quantity.

The following is the program code:

.. literalinclude:: ../../../freenove_Kit/Code/Python_GPIOZero_Code/10.1.1_Nightlamp/Nightlamp.py
    :linenos: 
    :language: python

