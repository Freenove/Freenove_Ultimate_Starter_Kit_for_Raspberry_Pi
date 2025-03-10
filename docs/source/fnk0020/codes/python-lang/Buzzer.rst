################################################################
Chapter Buzzer
################################################################

In this chapter, we will learn about buzzers and the sounds they make. And in our next project, we will use an active buzzer to make a doorbell and a passive buzzer to make an alarm.

Project Doorbell
****************************************************************

We will make a doorbell with this functionality: when the Push Button Switch is pressed the buzzer sounds and when the button is released, the buzzer stops. This is a momentary switch function.

+-----------------------------------------------------------+
|    Raspberry Pi (with 40 GPIO) x1                         |     
|                                                           |       
|    GPIO Extension Board & Ribbon Cable x1                 |       
|                                                           |                                                            
|    Breadboard x1                                          |                                                                 
+---------------------------+-------------------------------+
| NPN transistorx1 (S8050)  |   Active buzzer x1            |
|                           |                               |
|   |NPN-transistor|        |  |Active-buzzer|              |                   
|                           |                               |          
+----------------------+----+------------+------------------+
|Push Button Switch x1 | Resistor 1kΩ x1 | Resistor 10kΩ x2 |
|                      |                 |                  |
| |button-small|       | |Resistor-1kΩ|  | |Resistor-10kΩ|  |
|                      |                 |                  |
+----------------------+-----------------+------------------+
|   Jumper Wire                                             |
|                                                           | 
|      |jumper-wire|                                        |
+-----------------------------------------------------------+

.. |jumper-wire| image:: ../_static/imgs/jumper-wire.png
    :width: 60%
.. |Resistor-1kΩ| image:: ../_static/imgs/Resistor-1kΩ.png
    :width: 18%
.. |Resistor-10kΩ| image:: ../_static/imgs/Resistor-10kΩ.png
    :width: 16%
.. |button-small| image:: ../_static/imgs/button-small.jpg
    :width: 30%
.. |Active-buzzer| image:: ../_static/imgs/Active-buzzer.png
    :width: 30%
.. |NPN-transistor| image:: ../_static/imgs/NPN-transistor.png
    :width: 25%

Component knowledge
================================================================

Buzzer
----------------------------------------------------------------

A buzzer is an audio component. They are widely used in electronic devices such as calculators, electronic alarm clocks, automobile fault indicators, etc. There are both active and passive types of buzzers. Active buzzers have oscillator inside, these will sound as long as power is supplied. Passive buzzers require an external oscillator signal (generally using PWM with different frequencies) to make a sound.

.. container:: centered
    
    Active buzzer

.. image:: ../_static/imgs/Active-buzzer-knowledge.png
    :width: 50%
    :align: center

.. container:: centered
    
    Passive buzzer

.. image:: ../_static/imgs/Passive-buzzer-knowledge.png
    :width: 50%
    :align: center

Active buzzers are easier to use. Generally, they only make a specific sound frequency. Passive buzzers require an external circuit to make sounds, but passive buzzers can be controlled to make sounds of various frequencies. The resonant frequency of the passive buzzer in this Kit is 2kHz, which means the passive buzzer is the loudest when its resonant frequency is 2kHz.

:red:`How to identify active and passive buzzer?`

1.	As a rule, there is a label on an active buzzer covering the hole where sound is emitted, but there are exceptions to this rule.
2.	Active buzzers are more complex than passive buzzers in their manufacture. There are many circuits and crystal oscillator elements inside active buzzers; all of this is usually protected with a waterproof coating (and a housing) exposing only its pins from the underside. On the other hand, passive buzzers do not have protective coatings on their underside. From the pin holes, view of a passive buzzer, you can see the circuit board, coils, and a permanent magnet (all or any combination of these components depending on the model.

.. image:: ../_static/imgs/Active-buzzer-bottom.png
    :width: 25%
    :align: center

.. container:: centered
    
    Passive buzzer

.. image:: ../_static/imgs/Passive-buzzer-bottom.png
    :width: 25%
    :align: center

.. container:: centered
    
    Passive buzzer

Transistors
----------------------------------------------------------------

A transistor is required in this project due to the buzzer's current being so great that GPIO of RPi's output capability cannot meet the power requirement necessary for operation. A NPN transistor is needed here to amplify the current. 

Transistors, full name: semiconductor transistor, is a semiconductor device that controls current think of a transistor as an electronic “amplifying or switching device”. Transistors can be used to amplify weak signals, or to work as a switch. Transistors have three electrodes (PINs): base (b), collector (c) and emitter (e). When there is current passing between "be" then "ce" will have a several-fold current increase (transistor magnification), in this configuration the transistor acts as an amplifier. When current produced by "be" exceeds a certain value, "ce" will limit the current output. at this point the transistor is working in its saturation region and acts like a switch. Transistors are available as two types as shown below: PNP and NPN,

.. image:: ../_static/imgs/PNP-transistor.png
    :width: 50%
    :align: center

.. container:: centered
    
    PNP transistor

.. image:: ../_static/imgs/NPN-transistor-2.png
    :width: 50%
    :align: center

.. container:: centered
    
    NPN transistor

.. note:: 

    :red:`In our kit, the PNP transistor is marked with 8550, and the NPN transistor is marked with 8050.`

Thanks to the transistor's characteristics, they are often used as switches in digital circuits. As micro-controllers output current capacity is very weak, we will use a transistor to amplify its current in order to drive components requiring higher current.

When we use a NPN transistor to drive a buzzer, we often use the following method. If GPIO outputs high level, current will flow through R1 (Resistor 1), the transistor conducts current and the buzzer will make sounds. If GPIO outputs low level, no current will flow through R1, the transistor will not conduct currentand buzzer will remain silent (no sounds).

When we use a PNP transistor to drive a buzzer, we often use the following method. If GPIO outputs low level, current will flow through R1. The transistor conducts current and the buzzer will make sounds. If GPIO outputs high level, no current flows through R1, the transistor will not conduct current and buzzer will remain silent (no sounds). Below are the circuit schematics for both a NPN and PNP transistor to power a buzzer.

======================================  ================================================
NPN transistor to drive buzzer            PNP transistor to drive buzzer

|NPN-Drive|                               |PNP-Drive|

======================================  ================================================

.. |NPN-Drive| image:: ../_static/imgs/NPN-Drive.png
.. |PNP-Drive| image:: ../_static/imgs/PNP-Drive.png

Circuit
================================================================

+------------------------------------------------------------------------------------------------+
|  Schematic diagram with RPi GPIO Extension Shield                                              |
|                                                                                                |
|   |Buzzer-Schematic|                                                                           |
+------------------------------------------------------------------------------------------------+
|   Hardware connection. If you need any support,please feel free to contact us via:             |
|                                                                                                |
|   support@freenove.com                                                                         | 
|                                                                                                |
|   |Buzzer-Fritizing|                                                                           |
|                                                                                                |
|    **Video:** https://youtu.be/R_dmi3YwY-U                                                     |
+------------------------------------------------------------------------------------------------+

.. |Buzzer-Schematic| image:: ../_static/imgs/Buzzer-Schematic.png
.. |Buzzer-Fritizing| image:: ../_static/imgs/Buzzer-Fritizing.png

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/R_dmi3YwY-U" frameborder="0" allowfullscreen></iframe>

.. note:: 

    in this circuit, the power supply for the buzzer is 5V, and pull-up resistor of the push button switch is connected to the 3.3V power feed. Actually, the buzzer can work when connected to the 3.3V power feed but this will produce a weak sound from the buzzer (not very loud).

Code
================================================================

In this project, a buzzer will be controlled by a push button switch. When the button switch is pressed, the buzzer sounds and when the button is released, the buzzer stops. It is analogous to our earlier project that controlled an LED ON and OFF.

Python Code Doorbell
----------------------------------------------------------------

First, observe the project result, then learn about the code in detail.

.. hint:: 
    
    :red:`If you have any concerns, please contact us via:`  support@freenove.com

1.	Use cd command to enter 06.1.1_Doorbell directory of Python code.

.. code-block:: console

    $ cd ~/Freenove_Kit/Code/Python_GPIOZero_Code/06.1.1_Doorbell

2.	Use python command to execute python code “Doorbell.py”.

.. code-block:: console

    $ python Doorbell.py

After the program is executed, press the push button switch and the buzzer will sound. Release the push button switch and the buzzer will stop.

The following is the program code:

.. literalinclude:: ../../../freenove_Kit/Code/Python_GPIOZero_Code/06.1.1_Doorbell/Doorbell.py
    :linenos: 
    :language: python

The code is exactly the same as when we used a push button switch to control an LED. You can also try using the PNP transistor to achieve the same results.

Import the Buzzer class that controls Buzzer from the gpiozero library.

.. code-block:: python

    from gpiozero import Buzzer, Button

Create the Buzzer class for controlling the Buzzer.

.. code-block:: python

    buzzer = Buzzer(17)

In GPIO Zero, you assign the when_pressed and when_released properties to set up callbacks on those actions. 

Once it detects that the button is pressed, it executes the specified function onButtonPressed().  Once it detects that the button is released, it executes the specified function onButtonReleased()

.. code-block:: python
    
    def loop():
        button.when_pressed = onButtonPressed
        button.when_released = onButtonReleased

For more information about the methods used by the Buzzer class in the GPIO Zero library,please refer to: https://gpiozero.readthedocs.io/en/stable/api_output.html#buzzer

Project Alertor
****************************************************************

Next, we will use a passive buzzer to make an alarm. 

The list of components and the circuit is similar to the doorbell project. We only need to take the Doorbell circuit and replace the active buzzer with a passive buzzer.

Code
================================================================

In this project, our buzzer alarm is controlled by the push button switch. Press the push button switch and the buzzer will sound. Release the push button switch and the buzzer will stop.

As stated before, it is analogous to our earlier project that controlled an LED ON and OFF. To control a passive buzzer requires PWM of certain sound frequency.

Python Code Alertor
----------------------------------------------------------------

First observe the project result, and then learn about the code in detail.

.. hint:: 
    
    :red:`If you have any concerns, please contact us via:`  support@freenove.com

1.	Use cd command to enter 06.2.1_Alertor directory of Python code.

.. code-block:: console

    $ cd ~/Freenove_Kit/Code/Python_GPIOZero_Code/06.2.1_Alertor

2.	Use the python command to execute the Python code “Alertor.py”.

.. code-block:: console

    $ python Alertor.py

After the program is executed, press the push button switch and the buzzer will sound. Release the push button switch and the buzzer will stop.

The following is the program code:

.. literalinclude:: ../../../freenove_Kit/Code/Python_GPIOZero_Code/06.2.1_Alertor/Alertor.py
    :linenos: 
    :language: python
    :dedent:

Define GPIO17 as the buzzer control pin, and GPIO18 as the button control pin to control the passive buzzer. It requires a certain frequency of PWM to control a passive buzzer, so the TonalBuzzer class is needed.

.. code-block:: python

    buzzer = TonalBuzzer(17)
    button = Button(18) # define Button pin according to BCM Numbering

In the while loop loop of the main function, when the push button switch is pressed the subfunction alertor() will be called and the alarm will issue a warning sound. The frequency curve of the alarm is based on a sine curve. We need to calculate the sine value from 0 to 360 degrees and multiplied by a certain value (here this value is 500) plus the resonant frequency of buzzer. We can set the PWM frequency through Tone(toneVal).

.. literalinclude:: ../../../freenove_Kit/Code/Python_GPIOZero_Code/06.2.1_Alertor/Alertor.py
    :linenos: 
    :language: python
    :lines: 24-26
    :dedent:

When the push button switch is released, the buzzer (in this case our Alarm) will stop.

.. code-block:: python

    def stopAlertor():
        buzzer.stop()

For more information about the methods used by the TonalBuzzer class in the GPIO Zero library,please refer to: https://gpiozero.readthedocs.io/en/stable/api_output.html#tonalbuzzer

