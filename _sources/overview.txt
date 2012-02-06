Overview
========

The XMOS CAN component implements the CAN 2.0 specification. This specification is available
at http://www.can-cia.org/fileadmin/cia/specifications/CAN20B.pdf

The following parts of the specification are implemented in the core CAN Phy component.

  * Transmit and receive timing and synchronization
  * Bit stuffing
  * Arbitration
  * Error detection
  * Error signalling
  * Acknowledgement
  * Bus-Off Fault recovery
  
A CAN LLC layer is provided, but is not complete.  It handles.

  * Message filtering
  * Responding to REMOTE frames
  * Overload management


Resource usage
==============

The following applies to the use of the CAN Phy thread.

+-----------+-------------+
| Resource  | Requirement |
+===========+=============+
| Threads   | 1           |
+-----------+-------------+
| Channels  | 2           |
+-----------+-------------+
| Ports     | 2 x 1 bit   |
+-----------+-------------+
| Clocks    | 1           |
+-----------+-------------+

Memory usage
++++++++++++

+------------------+----------------------+
| Component        | Memory usage / Bytes |
+==================+======================+
| CAN Phy thread   | 5600                 |
+------------------+----------------------+
| Client functions | 140                  |
+------------------+----------------------+
| Memory buffer    | Minimum 1 of 16      |
+------------------+----------------------+



MIPS required
+++++++++++++

+-------------+------------------+
| Bit rate    | MIPS required    |
+=============+==================+
| 500 kbps    | 25               |
+-------------+------------------+
| 1 Mbps      | 100              |
+-------------+------------------+





