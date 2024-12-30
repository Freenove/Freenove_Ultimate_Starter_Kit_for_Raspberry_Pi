################################################################
Chapter Servo
################################################################


Previously, we learned how to control the speed and rotational direction of a DC Motor. In this chapter, we will learn about Servos which are a rotary actuator type motor that can be controlled rotate to specific angles.

Project Servo Sweep
****************************************************************

First, we need to learn how to make a Servo rotate.

Component List
================================================================

+-------------------------------------------------+-------------------------------------------------+
|1. Raspberry Pi (with 40 GPIO) x1                |                                                 |     
|                                                 | Servo x1                                        |       
|2. GPIO Extension Board & Ribbon Cable x1        |                                                 |       
|                                                 |  |Servo|                                        |                                                            
|3. Breadboard x1                                 |                                                 |                                                                 
+-------------------------------------------------+-------------------------------------------------+
|  Jumper Wires x3                                                                                  |
|                                                                                                   |
|  |jumper-wire|                                                                                    |                           
+---------------------------------------------------------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
    :width: 70%
.. |Servo| image:: ../_static/imgs/Servo.png
    :width: 70%

Component knowledge
================================================================

Servo
----------------------------------------------------------------

Servo is a compact package which consists of a DC Motor, a set of reduction gears to provide torque, a sensor and control circuit board. Most Servos only have a 180-degree range of motion via their “horn”. Servos can output higher torque than a simple DC Motor alone and they are widely used to control motion in model cars, model airplanes, robots, etc. Servos have three wire leads which usually terminate to a male or female 3-pin plug. Two leads are for electric power: Positive (2-VCC, Red wire), Negative (3-GND, Brown wire), and the signal line (1-Signal, Orange wire) as represented in the Servo provided in your Kit.

.. image:: ../_static/imgs/Servo-1.png
    :align: center

We will use a 50Hz PWM signal with a duty cycle in a certain range to drive the Servo. The lasting time 0.5ms-2.5ms of PWM single cycle high level corresponds to the Servo angle 0 degrees - 180 degree linearly. Part of the corresponding values are as follows:

.. note:: 
    
    the lasting time of high level corresponding to the servo angle is absolute instead of accumulating. For example, the high level time lasting for 0.5ms correspond to the 0 degree of the servo. If the high level time lasts for another 1ms, the servo rotates to 45 degrees.

================  ================
 High level time  Servo angle
================  ================
0.5ms             0 degree
1ms               45 degree
1.5ms             90 degree
2ms               135 degree
2.5ms             180 degree
================  ================

When you change the Servo signal value, the Servo will rotate to the designated angle.

Circuit
================================================================

Use caution when supplying power to the Servo it should be 5V. Make sure you do not make any errors when connecting the Servo to the power supply.

+------------------------------------------------------------------------------------------------+
|   Schematic diagram                                                                            |
|                                                                                                |
|   |Servo-Sc|                                                                                   |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         |
|                                                                                                |
|   |Servo-Fr|                                                                                   |
|                                                                                                |
|    **Video:** https://youtu.be/leptbJh32ZI                                                     |
|                                                                                                |
|    **Sorry latter chapters don't have videos yet.**                                            |
+------------------------------------------------------------------------------------------------+

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/leptbJh32ZI" frameborder="0" allowfullscreen></iframe>

.. |Servo-Sc| image:: ../_static/imgs/Servo-Sc.png
.. |Servo-Fr| image:: ../_static/imgs/Servo-Fr.png

Code
================================================================

In this project, we will make a Servo rotate from 0 degrees to 180 degrees and then reverse the direction to make it rotate from 180 degrees to 0 degrees and repeat these actions in an endless loop.

Python Code 15.1.1 Sweep
----------------------------------------------------------------

First observe the project result, and then learn about the code in detail.

.. hint:: 
    :red:`If you have any concerns, please contact us via:`  support@freenove.com

1.	Use cd command to enter 15.1.1_Sweep directory of Python code.

.. code-block:: console

    $ cd ~/Freenove_Kit/Code/Python_GPIOZero_Code/15.1.1_Sweep

2.	Use python command to execute code "Sweep.py".

.. code-block:: console

    $ python Sweep.py

After the program is executed, the Servo will rotate from 0 degrees to 180 degrees and then reverse the direction to make it rotate from 180 degrees to 0 degrees and repeat these actions in an endless loop.

The following is the program code:

.. literalinclude:: ../../../freenove_Kit/Code/Python_GPIOZero_Code/15.1.1_Sweep/Sweep.py
    :linenos: 
    :language: python

Import the AngularServo class that controls Servo from the gpiozero library.

.. code-block:: python

    from gpiozero import AngularServo

A 50 Hz pulse for a 20ms cycle is required to control the Servo. By default, the AngularServo class has set the control period to 20 milliseconds.

.. code-block:: python

    servo =  AngularServo(myGPIO,initial_angle=0,min_angle=0, max_angle=180,min_pulse_width=minPW,max_pulse_width=maxPW)

The 0-180 degree rotation of the servo corresponds to a PWM pulse width of 0.5-2.5ms at a period of 20ms and a duty cycle of 2.5%-12.5%. After setting the AngularServo class and passing in the corresponding angle parameters, the servo will turn to the corresponding position. However, in actual operation, as there is a deviation in the width of the servo pulse, we need to define minimum and maximum pulse width and error offset (this is essential in robotics).

.. literalinclude:: ../../../freenove_Kit/Code/Python_GPIOZero_Code/15.1.1_Sweep/Sweep.py
    :linenos: 
    :language: python
    :lines: 13-27

For more information about the methods used by the AngularServo class in the GPIO Zero library,please refer to:https://gpiozero.readthedocs.io/en/stable/api_output.html#angularservo

In the above experiment, you can see that the servo jitter obviously when working.

.. note:: 
    
    To reduce servo jitter, use the pigpio pin driver rather than the default RPi.GPIO driver (pigpio uses DMA sampling for much more precise edge timing).

You can refer to the code sweep2.py for more details.

1.  Use cd command to enter 15.1.1_Sweep directory of Python code.

.. code-block:: console

    $ cd ~/Freenove_Kit/Code/Python_GPIOZero_Code/15.1.1_Sweep

2.  Use python command to execute code "Sweep.py".

.. code-block:: console

    $ python Sweep2.py

After the program executes, the servo will rotate from 0 degrees to 180 degrees, then reverse the direction so it rotates from 180 degrees to 0 degrees, and repeat these actions in an infinite loop. At this time, the steering gear can hardly feel the vibration.

This code is based on pigpio. In the latest Raspberry Pi OS, “pigpio” library has been installed. You only need to run the command to enable it.

.. code-block:: console

    $ sudo pigpiod

.. image:: ../_static/imgs/sudo_pigpiod.png
    :align: center

If the “pigpio” library has not yet been installed, please follow the steps to install it.
Run the command to install “pigpio” library.

.. code-block:: console

    $ sudo apt-get update
    $ sudo apt-get install pigpio python-pigpio python3-pigpio

The following is the program code:

.. literalinclude:: ../../../freenove_Kit/Code/Python_GPIOZero_Code/15.1.1_Sweep2/Sweep2.py
    :linenos: 
    :language: python

The following values, and the corresponding Factory and Pin classes are listed in the table below. Factories are listed in the order that they are tried by default.

.. list-table::
   :align: center
   :header-rows: 1
   :class: product-table

   * - Name
     - Factory class
     - Pin class

   * - rpigpio
     - gpiozero.pins.rpigpio.RPiGPIOFactory
     - gpiozero.pins.rpigpio.RPiGPIOPin

   * - lgpio
     - gpiozero.pins.lgpio.LGPIOFactory
     - gpiozero.pins.lgpio.LGPIOPin
    
   * - rpio
     - gpiozero.pins.rpio.RPIOFactory
     - gpiozero.pins.rpio.RPIOPin

   * - pigpio
     - gpiozero.pins.pigpio.PiGPIOFactory
     - gpiozero.pins.pigpio.PiGPIOPin

   * - native
     - gpiozero.pins.native.NativeFactory
     - gpiozero.pins.native.NativePin
    
See Changing the pin factory for further information: https://gpiozero.readthedocs.io/en/stable/api_pins.html#changing-pin-factory
