#include <platform.h>
#include <print.h>

#include "CanIncludes.h"
#include "CanFunctions.h"
#include "CanPhy.h"


on stdcore[0]: port p_can_tx = PORT_CAN_TX;
on stdcore[0]: buffered in port:32 p_can_rx = PORT_CAN_RX;
on stdcore[0]: clock can_clk = XS1_CLKBLK_1;

on stdcore[0]: port p_reset = PORT_SHARED_RS;

on stdcore[0]: out port p_leds = PORT_LEDS;
on stdcore[0]: in port p_buttons = PORT_BUTTONS;

/*
 *  This demo function uses events to either receive a packet from the CAN PHY layer,
 *  or to detect a change in the state of the buttons. A button state change will trigger
 *  a CAN transmission with the current button state. A CAN RX will update the LEDs to
 *  match the data in the CAN packet, provided it is targeted at unit ID 1
 */
void canDemo(chanend c_rx, chanend c_tx)
{
	unsigned buttons;
	p_buttons :> buttons;
	p_leds <: 0x0;

	while (1) {
		struct CanPacket packet;
		unsigned v;

		select {
			case inuint_byref(c_rx, v): {
				receivePacket(c_rx, packet);

				if (packet.ID == 1 && packet.DLC >= 1) {
					p_leds <: (packet.DATA[0] << 4);
				}
				break;
			}

			case p_buttons when pinsneq(buttons) :> buttons: {
				initPacket(packet);
				packet.ID = 2;
				packet.DATA[0] = buttons;
				packet.DLC = 1;
				outuint(c_tx, 0);
				sendPacket(c_tx, packet);
				break;
			}
		}
	}
}

int main()
{
	chan c_rx, c_tx;

    par {
        on stdcore[0]: canDemo(c_rx, c_tx);

        on stdcore[0]: {
        	p_reset <: 0;
        	canPhyRxTx(c_rx, c_tx, can_clk, p_can_rx, p_can_tx);
        }
    }

    return 0;
}
