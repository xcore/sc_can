#include "can.h"

int can_send_frame(chanend c_can_server, const can_frame &frm){
  int r;
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
  return r;
}

void can_send_frame_nonblocking(chanend c_can_server, const can_frame &frm){
	c_can_server <: (char)TX_FRAME_NB;
  master {
	  c_can_server <: frm.remote;
	  c_can_server <: frm.extended;
	  c_can_server <: frm.id;
	  c_can_server <: frm.dlc;
	  c_can_server <: (frm.data, unsigned[])[0];
	  c_can_server <: (frm.data, unsigned[])[1];
  }
}

int can_pop_frame(chanend c_can_server, can_frame &frm){
  unsigned count;
  c_can_server <: (char)POP_FRAME;
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
  return (count - 1);
}

unsigned can_get_status(chanend c_can_server){
  unsigned s;
  c_can_server <: (char)GET_STATUS;
  c_can_server :> s;
  return s;
}

void can_reset(chanend c_can_server){
  c_can_server <: (char)RESET;
}

unsigned can_add_filter(chanend c_can_server, unsigned id){
  unsigned ret;
  c_can_server <: (char)ADD_FILTER;
  c_can_server <: id;
  c_can_server :> ret;
  return ret;
}

unsigned can_remove_filter(chanend c_can_server, unsigned id){
  unsigned ret;
  c_can_server <: (char)REMOVE_FILTER;
  c_can_server <: id;
  c_can_server :> ret;
  return ret;
}
