CAN Bus Module
==============

:scope: General Use
:description: CAN Bus component
:keywords: CAN,Rx,Tx
:boards: XA-SK-ISBUS

Features
--------

   * frame id filtering,
   * configurable size rx frame buffer,
   * Fully CAN 2.0A and 2.0B compilant.
   * Up to 1Mb baud rate
   * Support for extended identifier(29-bit) for PHY layer

Future Work
-----------
Avaliable for future work is:
   - Add a Tx buffer.
   - Extra server functionality:
       * FLUSH_BUFFER_RX
       * FLUSH_BUFFER_TX
       * SET_CLOCK_DIVIDER
       * SET_STATUS
   - Force dedicated node ID for performance
   - Filter on single ID for performance
   - Statistics gathering