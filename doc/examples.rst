Example Applications
====================

This tutorial describes the demo applications included in the XMOS SDRAM software component. 
:ref:`sec_hardware_platforms` describes the required hardware setups to run the demos.

app_sdram_demo
--------------

This application demonstrates how the module is used to accesses memory on the SDRAM. The purpose of this application is to show how data is written to and read from the SDRAM in a safe manner.

Getting Started
+++++++++++++++

   #. Plug the XA-SK-ISBUS Slice Card into the 'STAR' slot of the Slicekit Core Board.
   #. Plug the XA-SK-XTAG2 Card into the Slicekit Core Board.
   #. Ensure the XMOS LINK switch on the XA-SK-XTAG2 is set to "off".
   #. Open ``app_can_demo.xc`` and build it.
   #. run the program on the hardware.

The demo will transmit and display a random frame every 5 seconds and display any frames it recieves.

Notes
+++++
 - The demo runs at 500Kb/s
 - The CAN node (ISBUS Slice) must be connected to a CAN network with active nodes to run this demo.
 - If the network is too noisy then the demo might change to a passive state then to 'bus off' in which case then demo is over.

