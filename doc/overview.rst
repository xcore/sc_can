Overview
========

CAN Bus Controller Component
----------------------------
CAN bus is a multi-master broadcast serial bus standard designed specifically for automotive applications where a noisy environment is present but now also used in other areas such as industrial automation and medical equipment. The CAN Bus module is designed for XCore devices to interface directly with a CAN phy in order to communicate on a CAN bus. It requires the minimum two pins, fits in less than 3KB and is fully CAN 2.0 compilant. 


CAN Bus Component Features
++++++++++++++++++++++++++

The CAN Bus component has the following features:

  * Configurability of 
     * segment time quantum,
     * bus baud rate,
     * maximum filter entries.
  * Supports
     * frame id filtering,
     * configurable size frame buffer,
     * Fully CAN 2.0A and 2.0B compliant,
     * Up to 1Mb baud rate,
     * Support for extended identifier(29-bit) for PHY layer,
  * Low xCORE resource usage
     * The function ``can_server`` requires just one core, the client functions, located in ``can.h`` are very low overhead and are called from the application,
     * 2 timers used,
     * A single channel,
     * Two one bit pins.

Memory requirements
+++++++++++++++++++

+------------------+----------------------------------------+
| Resource         | Usage                            	    |
+==================+========================================+
| Stack            | 538 bytes                              |
+------------------+----------------------------------------+
| Program          | 3690 bytes                             |
+------------------+----------------------------------------+

Resource requirements
+++++++++++++++++++++

+---------------+-------+
| Resource      | Usage |
+===============+=======+
| Channels      |   1   |
+---------------+-------+
| Timers        |   2   |
+---------------+-------+
| Clocks        |   1   |
+---------------+-------+
| Logical Cores |   1   |
+---------------+-------+

Performance
+++++++++++
The achievable effective bandwidth varies according to the available XCore MIPS and CAN bus speed. At 125MIPS up to 1Mb/s baud rate and at 62.5MIPS up to 500Kb/s baud rate will allow the full 1.58% oscillator tolerance.


