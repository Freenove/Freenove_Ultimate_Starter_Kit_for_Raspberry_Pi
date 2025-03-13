.. _Preparation:

##############################################################################
0. Chapter Preparation
##############################################################################

Why “Chapter 0”? Because in program code the first number is 0. We choose to follow this rule. In this chapter, we will do some necessary foundational preparation work: Start your Raspberry Pi and install some necessary libraries. 

video: https://www.youtube.com/watch?v=dO657Odse5U

.. raw:: html

   <iframe height="500" width="690" src="https://www.youtube.com/embed/dO657Odse5U" frameborder="0" allowfullscreen></iframe>

Linux Command
****************************************************************

Raspberry Pi OS is based on the Linux Operation System. Now we will introduce you to some frequently used Linux commands and rules.

First, open the Terminal. All commands are executed in Terminal. 

.. image:: ../_static/p00-imgs/chapter00-01.png

When you click the Terminal icon, following interface appears.

.. image:: ../_static/p00-imgs/chapter00-02.png

**Note: The Linux is case sensitive.**

First, type ``ls`` into the Terminal and press the “Enter” key. The result is shown below:

.. image:: ../_static/p00-imgs/chapter00-03.png

The ``ls`` command lists information about the files (the current directory by default).

Content between ``$`` and ``pi@raspberrypi:`` is the current working path. ``~`` represents the user directory, which refers to ``/home/pi`` here. 

.. image:: ../_static/p00-imgs/chapter00-04.png

``cd`` is used to change directory. / represents the root directory. 

.. image:: ../_static/p00-imgs/chapter00-05.png

Later in this Tutorial, we will often change the working path. Typing commands under the wrong directory may cause errors and break the execution of further commands. 

Many frequently used commands and instructions can be found in the following reference table.
    
+---------------+--------------------------------------------------------------------------------------------------+
| Command       | instruction                                                                                      |
+===============+==================================================================================================+
| ls            | Lists information about the FILEs (the current directory by default) and entries alphabetically. |
+---------------+--------------------------------------------------------------------------------------------------+
| cd            | Changes directory                                                                                |
+---------------+--------------------------------------------------------------------------------------------------+
| sudo + cmd    | Executes cmd under root authority                                                                |
+---------------+--------------------------------------------------------------------------------------------------+
| ./            | Under current directory                                                                          |
+---------------+--------------------------------------------------------------------------------------------------+
| gcc           | GNU Compiler Collection                                                                          |
+---------------+--------------------------------------------------------------------------------------------------+
| git clone URL | Use git tool to clone the contents of specified repository, and URL in the repository address.   |
+---------------+--------------------------------------------------------------------------------------------------+

There are many commands, which will come later. 

.. seealso:: 
    For more details about commands. You can refer to:
    http://www.linux-commands-examples.com

Shortcut Key
================================================================

Now, we will introduce several commonly used shortcuts that are very useful in Terminal.

1. **Up and Down Arrow Keys:** Pressing “↑” (the Up key) will go backwards through the command history and pressing “↓” (the Down Key) will go forwards through the command history.

2. **Tab Key:** The Tab key can automatically complete the command/path you want to type. When there is only one eligible option, the command/path will be completely typed as soon as you press the Tab key even you only type one character of the command/path. 

As shown below, under the '~' directory, you enter the Documents directory with the “cd” command. After typing “cd D”, pressing the Tab key (there is no response), pressing the Tab key again then all the files/folders that begin with “D” will be listed. Continue to type the letters "oc" and then pressing the Tab key, the “Documents” is typed automatically.

.. image:: ../_static/p00-imgs/chapter00-06.png

.. image:: ../_static/p00-imgs/chapter00-07.png

Install WiringPi
****************************************************************

WiringPi is a GPIO access library written in C language for the used in the Raspberry Pi. 

WiringPi Installation Steps
================================================================
To install the WiringPi library, please open the Terminal and then follow the steps and commands below.  

.. note::
    For a command containing many lines, execute them one line at a time.

Enter the following commands **one by one** in the **terminal** to install WiringPi:

.. code-block:: console

    $ sudo apt-get update
    $ git clone https://github.com/WiringPi/WiringPi
    $ cd WiringPi
    $ ./build

.. image:: ../_static/p00-imgs/chapter00-08.png

The following figure shows the successful installation.

.. image:: ../_static/p00-imgs/chapter00-09.png

Run the gpio command to check the installation:

.. code-block:: console
    
    $ gpio -v

That should give you some confidence that the installation was a success.

.. image:: ../_static/p00-imgs/chapter00-10.png

Obtain the Project Code
****************************************************************

After the above installation is completed, you can visit our official website (http://www.freenove.com) or 
our GitHub resources at (https://github.com/freenove) to download the latest available project code. 
We provide both :red:`C` language and :red:`Python` language code for each project to allow ease of use for those who are skilled in either language. 

This is the method for obtaining the code:

In the pi directory of the RPi terminal, enter the following command.

.. code-block:: console
    
    $ cd
    $ git clone --depth 1 https://github.com/freenove/Freenove_Complete_Starter_Kit_for_Raspberry_Pi

:red:`(There is no need for a password. If you get some errors, please check your commands.)`

.. image:: ../_static/p00-imgs/chapter00-11.png

.. image:: ../_static/p00-imgs/chapter00-12.png

After the download is completed, a new folder "Freenove_Complete_Starter_Kit_for_Raspberry_Pi" is generated, which contains all of the tutorials and required code.

:red:`This folder name seems a little too long. We can simply rename it by using the following command.` 

.. code-block:: console
    
    $ mv Freenove_Complete_Starter_Kit_for_Raspberry_Pi/ Freenove_Kit/

``Freenove_Kit`` is now the new and much shorter folder name.

.. image:: ../_static/p00-imgs/chapter00-13.png

.. image:: ../_static/p00-imgs/chapter00-14.png