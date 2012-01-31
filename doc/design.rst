Design
======

The CAN Phy component provides a thread that interfaces to a transmit and a receive port,
and provides a two channel interface for an application thread to transmit and receive
packets on this interface.

Server
++++++

The thread function for the CAN Phy is called **canPhyRxTx**.  As parameters it
takes a receive and a transmit channel to send a recieve packets on. It also takes
a clock block, and a transmit and receive port.  These should both be one bit ports. 


Client
++++++

For the client, two functions provide the ability to send and receive data.

  * sendPacket
  * receivePacket

Prior to sending a packet, a single unsigned integer should be pushed into the
transmit channel, in order to prime the server for the reception of the packet.

Below is a snippet of code that sends a packet to the CAN Phy.

::
  struct CanPacket packet;
  packet.ID = 2;
  packet.DATA[0] = buttons;
  packet.DLC = 1;
  outuint(c_tx, 0);
  sendPacket(c_tx, packet);

The packet structure can be cleared using the **initPacket** function, although this
is not necessary.


Prior to receiving a packet from the Phy thread, a single unsigned integer needs to be
received from the Rx channel.  This unsigned integer can be used to select on a packet
being available for reception.

Below is a snippet of code showing reception.

::
  int v;
  struct CanPacket packet;
  select {
    case inuint_byref(c_rx, v): {
      receivePacket(c_rx, packet);
      break;
    }
  }        
            
The case allows the packet reception to be event driven.



