#include "can.h"
#include "mutual_thread_comm.h"

int can_send_frame(chanend c_can_server, const can_frame &frm){
  int r;
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)TX_FRAME;
  master {
	  c_can_server <: frm.remote;
	  c_can_server <: frm.extended;
	  c_can_server <: frm.id;
	  c_can_server <: frm.dlc;
	  c_can_server <: (frm.data, unsigned[])[0];
	  c_can_server <: (frm.data, unsigned[])[1];
  }
  c_can_server :> r;
  mutual_comm_complete(c_can_server);
  return r;
}

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

void can_send_frame_nonblocking(chanend c_can_server, const can_frame &frm){
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)TX_FRAME_NB;
  master {
	  c_can_server <: frm.remote;
	  c_can_server <: frm.extended;
	  c_can_server <: frm.id;
	  c_can_server <: frm.dlc;
	  c_can_server <: (frm.data, unsigned[])[0];
	  c_can_server <: (frm.data, unsigned[])[1];
  }
  mutual_comm_complete(c_can_server);
}

unsigned can_get_status(chanend c_can_server){
  unsigned s;
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)GET_STATUS;
  c_can_server :> s;
  mutual_comm_complete(c_can_server);
  return s;
}

void can_reset(chanend c_can_server){
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)RESET;
  mutual_comm_complete(c_can_server);
  // Clear notification flag.
  mutual_comm_notified(c_can_server);
  mutual_comm_complete(c_can_server);
}

unsigned can_add_filter(chanend c_can_server, unsigned id){
  unsigned ret;
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)ADD_FILTER;
  c_can_server <: id;
  c_can_server :> ret;
  mutual_comm_complete(c_can_server);
  return ret;
}

unsigned can_remove_filter(chanend c_can_server, unsigned id){
  unsigned ret;
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)REMOVE_FILTER;
  c_can_server <: id;
  c_can_server :> ret;
  mutual_comm_complete(c_can_server);
  return ret;
}

unsigned can_rx_entries(chanend c_can_server){
  unsigned ret;
  mutual_comm_initiate(c_can_server);
  c_can_server <: (char)RX_BUF_ENTRIES;
  c_can_server :> ret;
  mutual_comm_complete(c_can_server);
  return ret;
}
