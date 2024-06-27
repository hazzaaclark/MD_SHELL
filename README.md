# MD_SHELL
SEGA MEGA DRIVE Shell Utility for Debugging 

# Motive:

The ambition behind this project is to provide a mutli-faceted means of being able to debu SEGA MEGA DRIVE games at runtime.

This is made possible by handling exceptions and aims to aid in realtime debugging of Mega Drive ROMs in Emulator and on real hardware

Through this, the debugger will display the relevant text elements on the screen in conjunction with which code is being executed at that current time

# Structure:

This project is split up into two different yet concurrent sections that work in tandem with one another

- A Termianl-like environment with an ease of use means of rendering text onto the screen
- The Debugger which looks to disassemble Opcodes and relevant instructions on the fly

# Building:

As of right now, this project can be built using the provided ``./buid.bat`` file - albeit it is very basic in structure 

You will need to have ``ASM68K`` as a pre-requisite to be able to build this project 

# Demonstration:

![image](https://github.com/hazzaaclark/MD_SHELL/assets/107435091/07bfc642-f7e6-4d82-bbb4-cff66038b16c)

