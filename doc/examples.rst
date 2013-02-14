Example Applications
====================

This tutorial describes the demo applications included in the XMOS SDRAM software component. 
:ref:`sec_hardware_platforms` describes the required hardware setups to run the demos.

Demonstration Applications
==========================

app_can_demo
------------

This application demonstrates how the module_can is used to send and receive CAN Bus frames. The demonstration reports all traffic on the CAN bus until the demo is ended.
The demo will transmit and display a random frame every 0.5 seconds and display any frames it recieves.

Notes
+++++
 - The demo runs at 500Kb/s
 - Requires a CANdo USB dongle and a Windows machine.
 - The CAN node (ISBUS Slice) must be connected to a CAN network with active nodes to run this demo.
 - If the network is too noisy then the demo might change to a passive state then to 'bus off' in which case then demo is over.

app_can_dummy_demo
------------------

This application demonstrates how the module_can_dummy is used. It behaves exactly the same, with respect to rx and tx, as the module_can but allows testing wothout hardware.

Regression Applications
=======================

app_can_osc
------------

This application is used for testing that the CAN node can conform to the ocsillator tollerance of the CAN specification.

Notes
+++++
 - Requires two ISBUS slices

app_can_error_inject
--------------------

This application is used for testing that the CAN node can handle a noisy bus. It does this by using a ISBUS slice to inject dominant errors whilst ensuring correct rx and tx.

Notes
+++++
 - Requires three ISBUS slices

app_can_arbitrate
-----------------

This application is used for testing that the CAN node can conform to the arbitration rules of the CAN specification.

Notes
+++++
 - Requires three ISBUS slices

 
