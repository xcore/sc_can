XCORE.com CAN SOFTWARE COMPONENT
.................................

:Stable release:
:Status:  Feature complete
:Maintainer:  https://github.com/DavidNorman
:Description: Controller Area Network component including RX/TX and LLC (Link Layer Controller)

Key Features
============

   * two threads for each of the node one for LLC & other for PHY layer.
   * Baud Rates up to 1Mbps
   * Support for extended identifier(29-bit) for PHY layer
   * Support for dynamic bit rate control
   

Firmware Overview
=================

RX and TX are executed as functions which each run in PHY layer which in turn passes messages to & from LLC layer.

A demo appliction is included.

KNOWN ISSUES
============

none

Required Modules
================

xcommon

Intructions for Building Project 
================================

The CAN component is built using (XDE) Version: 10.4.2 (build 1752) or later.

This module can be demonstrated on XC-1 board with two CAN transceiver chips connected via ports 1A, 1B, 1C and 1D.
Also this board should be connected through a CAN USB dongle to a PC 

There are the settings required for hyperterminal setup for use with the demo app:

ASCII set up :
++++++++++++++

+untick the following options :

* send line ends with line feeds
* force incoming data to 7 bit ascii

+tick following options :

* echo typed characters locally 
* append line feeds to incoming line ends 
* wrap lines that exceed terminal widths 

Port settings :

bits per second : 115200
parity 	    	: none
data bits	: 8
stop bits       : 1
flow control    : none
 
This will display the CAN packet on the console window, which are monitored by the CAN dongle.
On successful CAN communication by LLC & PHY layer from one node to another node , glow 4 LEDs green on the board , else 
4 LEDs red.
 
 Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the maintainer for this line.
