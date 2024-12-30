##############################################################################
Chapter LED
##############################################################################


This chapter is the Start Point in the journey to build and explore RPi electronic projects. We will start with simple “Blink” project.

Project Blink
****************************************************************

In this project, we will use RPi to control blinking a common LED.

Component List
================================================================

1.  | Raspberry Pi 
    | (Recommended: Raspberry Pi 5 / 4B / 3B+ / 3B) 
    | (Compatible: 3A+ / 2B / 1B+ / 1A+ / Zero W / Zero) 

    .. image:: ../_static/imgs/raspberrypi5.png
        :height: 100

2.  GPIO Extension Board & Ribbon Cable

    .. image:: ../_static/imgs/raspberrypi-extension-board.jpg
        :height: 100

3.  Breadboard x1

    .. image:: ../_static/imgs/breadborad-830.jpg
        :height: 100

4.  LED x1

    .. image:: ../_static/imgs/red-led.png
        :height: 100

5.  Resistor 220Ω x1

    .. image:: ../_static/imgs/res-220R.png
        :height: 100

6.  Jumper (some)

    .. image:: ../_static/imgs/jumper-wire.png
        :height: 20

In the components list, 3B GPIO, Extension Shield Raspberry and Breadboard are necessary for each project. Later, they will be reference by text only (no images as in above).

GPIO
================================================================
GPIO: General Purpose Input/Output. Here we will introduce the specific function of the pins on the Raspberry Pi and how you can utilize them in all sorts of ways in your projects. Most RPi Module pins can be used as either an input or output, depending on your program and its functions.

When programming GPIO pins there are 3 different ways to reference them: **GPIO Numbering**, **Physical Numbering** and **WiringPi GPIO Numbering**.

BCM GPIO Numbering
---------------------------------------------------------------
The Raspberry Pi CPU uses Broadcom (BCM) processing chips BCM2835, BCM2836 or BCM2837. GPIO pin numbers are assigned by the processing chip manufacturer and are how the computer recognizes each pin. The pin numbers themselves do not make sense or have meaning as they are only a form of identification. Since their numeric values and physical locations have no specific order, there is no way to remember them so you will need to have a printed reference or a reference board that fits over the pins.

Each pin’s functional assignment is defined in the image below:
    .. image:: ../_static/imgs/raspberrypi5-cc90.png
        :height: 500

    .. image:: ../_static/imgs/raspberrypi-pinout-bcm.png
        :height: 500

.. seealso:: 
    For more details about pin definition of GPIO, please refer to `<http://pinout.xyz/>`_

PHYSICAL Numbering
---------------------------------------------------------------

Another way to refer to the pins is by simply counting across and down from pin 1 at the top left (nearest to the SD card). This is 'Physical Numbering', as shown below:

.. image:: ../_static/imgs/PHYSICAL-Numbering.png
    :height: 200

WiringPi GPIO Numbering
---------------------------------------------------------------

Different from the previous two types of GPIO serial numbers, RPi GPIO serial number of the WiringPi are numbered according to the BCM chip use in RPi.

.. image:: ../_static/imgs/WiringPi-GPIO-Numbering.png
    :height: 500

.. seealso:: 
    For more details, please refer to `<https://projects.drogon.net/raspberry-pi/wiringpi/pins/>`_ 

You can also use the following command to view their correlation.

.. code-block:: console

    $ gpio readall

.. image:: ../_static/imgs/cmd-readall-console.png
    :height: 500

Circuit
================================================================

First, disconnect your RPi from the GPIO Extension Shield. Then build the circuit according to the circuit and hardware diagrams. After the circuit is built and verified correct, connect the RPi to GPIO Extension Shield. 

.. caution:: 
    CAUTION: Avoid any possible short circuits (especially connecting 5V or GND, 3.3V and GND)! 

.. warning:: 
    WARNING: A short circuit can cause high current in your circuit, create excessive component heat and cause permanent damage to your RPi!

1. **Schematic diagram**

.. image:: ../_static/imgs/blink-sch.png
    :height: 400

2. **Hardware connection** 

.. image:: ../_static/imgs/blink-hdc.png
    :height: 400

.. tip:: 
     :red:`If you need any support, please contact us via:` :blue:`support@freenove.com`

.. attention:: 
    Do NOT rotate Raspberry Pi to change the way of this connection.
    Please plug T extension fully into breadboard.

The connection of Raspberry Pi T extension board is as below. **Don't reverse the ribbon**.

.. image:: ../_static/imgs/blink-real.png
    :width: 100%

.. note:: 
    If you have a fan, you can connect it to 5V GND of breadboard via jumper wires.

**How to distinguish resistors?**

There are only three kind of resistors in this kit.

1. The one with *1 red ring* is 10KΩ \

    .. image:: ../_static/imgs/res-10K-hori.png
        :height: 20

2. The one with *1 red ring* is 10KΩ 

    .. image:: ../_static/imgs/res-220R-hori.png
        :height: 20

#. The one with *1 red ring* is 10KΩ 

    .. image:: ../_static/imgs/res-1K-hori.png
        :height: 20

.. note:: 
    Future hardware connection diagrams will only show that part of breadboard and GPIO Extension Shield.

Component knowledge
================================================================

LED
----------------------------------------------------------------
An LED is a type of diode. All diodes only work if current is flowing in the correct direction and have two Poles. An LED will only work (light up) if the longer pin (+) of LED is connected to the positive output from a power source and the shorter pin is connected to the negative (-) output, which is also referred to as Ground (GND). This type of component is known as “Polar” (think One-Way Street).

All common 2 lead diodes are the same in this respect. Diodes work only if the voltage of its positive electrode is higher than its negative electrode and there is a narrow range of operating voltage for most all common diodes of 1.9 and 3.4V. If you use much more than 3.3V the LED will be damaged and burnt out.

.. image:: ../_static/imgs/led-describe.png
    :width: 100%

.. note:: 
    Note: LEDs cannot be directly connected to a power supply, which usually ends in a damaged component. A resistor with a specified resistance value must be connected in series to the LED you plan to use.

Resistor
----------------------------------------------------------------
Resistors use Ohms (Ω) as the unit of measurement of their resistance (R). 1MΩ=1000kΩ, 1kΩ=1000Ω.

A resistor is a passive electrical component that limits or regulates the flow of current in an electronic circuit.

On the left, we see a physical representation of a resistor, and the right is the symbol used to represent the presence of a resistor in a circuit diagram or schematic.

.. image:: ../_static/imgs/res-describe.png

The bands of color on a resistor is a shorthand code used to identify its resistance value. For more details of resistor color codes, please refer to the card in the kit package.

With a fixed voltage, there will be less current output with greater resistance added to the circuit. The relationship between Current, Voltage and Resistance can be expressed by this formula: I=V/R known as Ohm’s Law where I = Current, V = Voltage and R = Resistance. Knowing the values of any two of these allows you to solve the value of the third.

In the following diagram, the current through R1 is: 

.. math:: I=U/R=5V/10kΩ=0.0005A=0.5mA.

.. image:: ../_static/imgs/res-current.png

.. warning:: 
    WARNING: Never connect the two poles of a power supply with anything of low resistance value (i.e. a metal object or bare wire) this is a Short and results in high current that may damage the power supply and electronic components.

.. note:: 
    Note: Unlike LEDs and Diodes, Resistors have no poles and re non-polar (it does not matter which direction you insert them into a circuit, it will work the same)

Resistor
----------------------------------------------------------------

Here we have a small breadboard as an example of how the rows of holes (sockets) are electrically attached. The left picture shows the ways the pins have shared electrical connection and the right picture shows the actual internal metal, which connect these rows electrically.

.. image:: ../_static/imgs/breadborad-top-wire.png
    :width: 48%

.. image:: ../_static/imgs/breadborad-bottom-wire.png
    :width: 48%

GPIO Extension Board
----------------------------------------------------------------

GPIO board is a convenient way to connect the RPi I/O ports to the breadboard directly. The GPIO pin sequence on Extension Board is identical to the GPIO pin sequence of RPi. 

.. image:: ../_static/imgs/raspberrypi-extension-describe.png
    :width: 90%
  
Sketch
================================================================

According to the circuit, when the GPIO17 of Raspberry Pi output level is high, the LED turns ON. Conversely, when the GPIO17 Raspberry Pi output level is low, the LED turns OFF. Therefore, we can let GPIO17 cycle output high and output low level to make the LED blink.

Sketch_01_Blink
----------------------------------------------------------------

First, enter where the project is located:

.. code-block:: console

    $ cd ~/Freenove_Kit/Pi4j/Sketches/Sketch_01_Blink

.. image:: ../_static/imgs/java_blink.png
    :align: center

.. image:: ../_static/imgs/java_blink_cd.png
    :align: center

Enter the command to run the code.

.. code-block:: console

    $ jbang Blink.java

.. image:: ../_static/imgs/java_blink_jbang.png
    :align: center

Upon the code runs, you can see the onboard blue LED blinks.

.. image:: ../_static/imgs/java_LED_blink.png
    :align: center

And on Raspberry Pi Terminal, you can see the corresponding messages printed.

.. image:: ../_static/imgs/java_blink_mes.png
    :align: center

Press CTRL-C to exit the program.

.. image:: ../_static/imgs/java_blink_exit.png
    :align: center

If you want to view or modify the code, you can open the code with Geany with the following command.

.. code-block:: console

    $ geany Blink.java

Click the icon to run the code.

.. image:: ../_static/imgs/java_blink_code.png
    :align: center

If the code fails to run, please check Geany Configuration.

The following is program code:


.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_01_Blink/Blink.java
    :linenos: 
    :language: java

At the beginning of the code, we use shebang command to inform Raspberry Pi that we are going to use JBangto run Java script.

.. code-block:: c

    ///usr/bin/env jbang "$0" "$@" ; exit $?   

Likewise, we specify the dependencies required for the script to run. This includes the different components of the SLF4J logging library and the Pi4J library and their version numbers.

.. code-block:: c

    //DEPS org.slf4j:slf4j-api:2.0.12  
    //DEPS org.slf4j:slf4j-simple:2.0.12  
    //DEPS com.pi4j:pi4j-core:2.6.0  
    //DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
    //DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  

Import Pi4J library and the Console class to facilitate creating and managing contexts and printing messages on the console.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_01_Blink/Blink.java
    :linenos: 
    :language: java
    :lines: 9-10

Assign the GPIO pin to the LED, and configure it as output mode.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_01_Blink/Blink.java
    :linenos: 
    :language: java
    :lines: 13-18

Use the try…finally structure to ensure the smooth running of the code.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_01_Blink/Blink.java
    :linenos: 
    :language: java
    :lines: 20-31

Make the LED turn on and off once every 1 second, repeat this process, and print prompt messages.

.. literalinclude:: ../../../freenove_Kit/Pi4j/Sketches/Sketch_01_Blink/Blink.java
    :linenos: 
    :language: java
    :lines: 21-28

Freenove Car, Robot and other products for Raspberry Pi
================================================================

We also have car and robot kits for Raspberry Pi. You can visit our website for details.

:xx-large:`https://www.amazon.com/freenove`

**FNK0043**--:green:`Freenove 4WD Smart Car Kit for Raspberry Pi`

.. image:: ../_static/imgs/43_1.png
.. image:: ../_static/imgs/43_2.png

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/4Zv0GZUQjZc" frameborder="0" allowfullscreen></iframe>
  
**FNK0050**--:green:`Freenove Robot Dog Kit for Raspberry Pi`

.. image:: ../_static/imgs/50_1.png
.. image:: ../_static/imgs/50_2.png

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/7BmIZ8_R9d4" frameborder="0" allowfullscreen></iframe>

**FNK0052**--:green:`Freenove_Big_Hexapod_Robot_Kit_for_Raspberry_Pi`

.. image:: ../_static/imgs/52_1.png
    :width: 50%
.. image:: ../_static/imgs/52_2.png
    :width: 40%

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/LvghnJ2DNZ0" frameborder="0" allowfullscreen></iframe>Freenove Car, Robot and other products for Raspberry Pi

We also have car and robot kits for Raspberry Pi. You can visit our website for details.

:xx-large:`https://www.amazon.com/freenove`

**FNK0043**--:green:`Freenove 4WD Smart Car Kit for Raspberry Pi`

.. image:: ../_static/imgs/43_1.png
.. image:: ../_static/imgs/43_2.png

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/4Zv0GZUQjZc" frameborder="0" allowfullscreen></iframe>
  
**FNK0050**--:green:`Freenove Robot Dog Kit for Raspberry Pi`

.. image:: ../_static/imgs/50_1.png
.. image:: ../_static/imgs/50_2.png

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/7BmIZ8_R9d4" frameborder="0" allowfullscreen></iframe>

**FNK0052**--:green:`Freenove_Big_Hexapod_Robot_Kit_for_Raspberry_Pi`

.. image:: ../_static/imgs/52_1.png
    :width: 50%
.. image:: ../_static/imgs/52_2.png
    :width: 40%

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/LvghnJ2DNZ0" frameborder="0" allowfullscreen></iframe>