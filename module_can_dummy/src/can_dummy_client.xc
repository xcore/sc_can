#include "can_dummy.h"

int can_send_frame(chanend c_can_server, const can_frame &frm){return CAN_TX_SUCCESS;}

void can_rx_frame(chanend c_can_server, can_frame &frm){
	mutual_comm_notified(c_can_server);
	master {
	  c_can_server :> frm.remote;
	  c_can_server :> frm.extended;
	  c_can_server :> frm.id;
	  c_can_server :> frm.dlc;
	  c_can_server :> (frm.data, unsigned[])[0];
	  c_can_server :> (frm.data, unsigned[])[1];
	}
	mutual_comm_complete(c_can_server);
}

int can_peek_latest(chanend c_can_server, can_frame &frm){
  unsigned count;
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)PEEK_LATEST;
  c_can_server :> count;
  if(count){
    master {
	  c_can_server :> frm.remote;
	  c_can_server :> frm.extended;
	  c_can_server :> frm.id;
	  c_can_server :> frm.dlc;
	  c_can_server :> (frm.data, unsigned[])[0];
	  c_can_server :> (frm.data, unsigned[])[1];
    }
  }
  mutual_comm_complete(c_can_server);
  return count;
}

unsigned can_rx_entries(chanend c_can_server){
	unsigned count;
	mutual_comm_initiate(c_can_server);
	c_can_server <: (char)RX_BUF_ENTRIES;
	c_can_server :> count;
	mutual_comm_complete(c_can_server);
	return 0;

}
void can_send_frame_nonblocking(chanend c_can_server, const can_frame &frm){}
unsigned can_get_status(chanend c_can_server){return CAN_STATE_ACTIVE;}
void can_reset(chanend c_can_server){}
unsigned can_add_filter(chanend c_can_server, unsigned id){return 0;}
unsigned can_remove_filter(chanend c_can_server, unsigned id){return 0;}

