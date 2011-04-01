XCORE.com CAN SOFTWARE COMPONENT
.................................

Firmware Release Version:

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

Included Modules and Applications
=================================

xmos_common

Intructions for Building Project 
================================
The Software Components for CAN are built using XMOS Development Environment (XDE) Version: 10.4.2 (build 1752) or later.
This module can be demonstarted on XC-1 board with two CAN transceiver chips connected via ports 1A, 1B, 1C and 1D.
Also this board should be connected through CAN USB to PC 
There are following settings required for hyperterminal :
ASCII set up :

+untick following options :
send line ends with line feeds
force incomming data to 7 bit ascii
+tick following options :
echo typed charaters locally 
append line feeds to incomming line ends 
wrap lines that exceedterminal widths 

Port settings :
bits per second : 115200
parity 	    	: none
data bits	    : 8
stop bits       : 1
flow control    : none
 
This will display the CAN packet,on console window , which are monitored by CAN USB connector.
On successful CAN communication by LLC & PHY layer from one node to another node , glow 4 LEDs green on the board , else 
4 LEDs red.
 
 Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the manitainer for this line.
