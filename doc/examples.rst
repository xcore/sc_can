Example Applications
====================

This tutorial describes the demo applications included in the XMOS SDRAM software component. 

Demonstration Applications
==========================

app_can_demo
------------

This application demonstrates how the module_can is used to send and receive CAN Bus frames. The demonstration reports all traffic on the CAN bus until the demo is ended.
The demo will transmit and display a random frame every 0.5 seconds and display any frames it receives.

Notes
+++++
 - The demo runs at 500Kbps
 - Requires a CANdo USB dongle and a Windows machine.
 - The CAN node (ISBUS Slice) must be connected to a CAN network with active nodes to run this demo.
 - If the network is too noisy then the demo might change to a passive state then to 'bus off' in which case then demo is over.


 
