##############################################################################
Chapter Buzzer
##############################################################################

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
    :width: 30%
.. |Resistor-1kΩ| image:: ../_static/imgs/Resistor-1kΩ.png
    :width: 23%
.. |Resistor-10kΩ| image:: ../_static/imgs/Resistor-10kΩ.png
    :width: 20%
.. |button-small| image:: ../_static/imgs/button-small.jpg
    :width: 30%
.. |Active-buzzer| image:: ../_static/imgs/Active-buzzer.png
    :width: 30%
.. |NPN-transistor| image:: ../_static/imgs/NPN-transistor.png
    :width: 30%

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
    In our kit, the PNP transistor is marked with 8550, and the NPN transistor is marked with 8050.

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
+------------------------------------------------------------------------------------------------+

.. |Buzzer-Schematic| image:: ../_static/imgs/Buzzer-Schematic.png
.. |Buzzer-Fritizing| image:: ../_static/imgs/Buzzer-Fritizing.png

.. note:: 
    in this circuit, the power supply for the buzzer is 5V, and pull-up resistor of the push button switch is connected to the 3.3V power feed. Actually, the buzzer can work when connected to the 3.3V power feed but this will produce a weak sound from the buzzer (not very loud).

Sketch
================================================================

In this chapter, we use a button to control the active buzzer. The code is similar to that in Chapter 3.

Sketch_06_1_Doorbell
----------------------------------------------------------------

First, enter where the project is located:

.. code-block:: console

    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_06_1_Doorbell

.. image:: ../_static/imgs/java_doorbell.png
    :align: center

Enter the command to run the code.

.. code-block:: console

    $ jbang Doorbell.java

.. image:: ../_static/imgs/java_doorbell_jbang.png
    :align: center

During the code running, press the button to sound the buzzer and release the button to stop it.

.. image:: ../_static/imgs/Buzzer-Fritizing.png
    :align: center

You can see messages printed on the terminal.

.. image:: ../_static/imgs/java_doorbell_mes.png
    :align: center

Press Ctrl+C to exit the code.

.. image:: ../_static/imgs/java_doorbell_exit.png
    :align: center

You can open the code with Geany to view and edit it, with the following command.

.. code-block:: console

    $ geany Doorbell.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_doorbell_code.png
    :align: center

If the code fails to run, please check :ref:`Geany Configuration<Geany_Configuration>`.

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_06_1_Doorbell/Doorbell.java
    :linenos: 
    :language: java

Please note that as the code is similar to that in chapter 3, here we do not explain it again.

In order to make the prompt messages printed by the terminal more conspicuous, we wrote the myprintln function to wrap the console.println function.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_06_1_Doorbell/Doorbell.java
    :linenos: 
    :language: java
    :lines: 17-20

Project Alertor
****************************************************************

Next, we will use a passive buzzer to make an alarm. 

The list of components and the circuit is similar to the doorbell project. We only need to take the Doorbell circuit and replace the active buzzer with a passive buzzer.

Sketch
================================================================

In this chapter, we use button to control the passive buzzer to make sound.

Sketch_Alertor
----------------------------------------------------------------

First, enter where the project is located:

.. code-block:: console

    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_06_2_Alertor

.. image:: ../_static/imgs/java_Alertor.png
    :align: center

Enter the command to run the code.

.. code-block:: console

    $ jbang Alertor.java

.. image:: ../_static/imgs/java_Alertor_run.png
    :align: center

When the code is running, press the button to sound the buzzer and release to stop it.

You can see messages printed on the terminal.

.. image:: ../_static/imgs/java_Alertor_mes.png
    :align: center

Press ctrl+C to exit the code.

.. image:: ../_static/imgs/java_Alertor_exit.png
    :align: center

You can open the code with Geany to view and edit it, with the following command.

.. code-block:: console

    $ geany Alertor.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_Alertor_code.png
    :align: center

If the code fails to run, please check :ref:`Geany Configuration<Geany_Configuration>`.

The following is program code:

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_06_2_Alertor/Alertor.java
    :linenos: 
    :language: java
    :dedent:

Create a pi4j context for manipulating the GPIOs, and define the GPIO numbers that control the keys and buzzer.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_06_2_Alertor/Alertor.java
    :linenos: 
    :language: java
    :lines: 84-88
    :dedent:

Initialize the button input pin, create a monitoring event, and assign the key value to buttonState when the button state changes.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_06_2_Alertor/Alertor.java
    :linenos: 
    :language: java
    :lines: 113-116
    :dedent:

Initialize the PWM pin that controls the passive buzzer.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_06_2_Alertor/Alertor.java
    :linenos: 
    :language: java
    :lines: 118-121
    :dedent:

When buttonState is 1, the passive buzzer sounds, and when buttonState is 0, the buzzer sound is turned off. Print the information in the console.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_06_2_Alertor/Alertor.java
    :linenos: 
    :language: java
    :lines: 125-131
    :dedent: