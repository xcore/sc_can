#include <platform.h>
#include <xscope.h>
#include <stdio.h>
#include <stdlib.h>
#include <xclib.h>
#include "can.h"
#include "can_utils.h"

on tile[0]: can_ports p_0 = { XS1_PORT_1F, XS1_PORT_1G, XS1_CLKBLK_1 };//star
on tile[0]: can_ports p_1 = { XS1_PORT_1L, XS1_PORT_1I, XS1_CLKBLK_2 };//triangle
on tile[1]: can_ports p_2 = { XS1_PORT_1F, XS1_PORT_1G, XS1_CLKBLK_1 };//square
on tile[1]: can_ports p_3 = { XS1_PORT_1L, XS1_PORT_1I, XS1_CLKBLK_2 };//circle

on tile[0]: port spare_0 = XS1_PORT_4A;
on tile[0]: port spare_1 = XS1_PORT_4E;
on tile[1]: port spare_2 = XS1_PORT_4A;
on tile[1]: port spare_3 = XS1_PORT_4E;

const unsigned size[2] = { 0x800, 0x20000000 };

void can_tx(chanend c_server, chanend c_internal, int master_node, unsigned seed) {
  can_frame frm;
  timer t;
  unsigned now;
  while(1){
    can_utils_make_random_frame(frm, seed);
    if(master_node){
      frm.id = (frm.id+master_node)&(size[frm.extended]-1);
    }

    if(master_node){
      t:> now;
      c_internal <: now;
    }
    c_internal :> now;
    t when timerafter(now):> int;

    if (can_send_frame(c_server, frm) == CAN_TX_FAIL) {
      can_utils_print_frame(frm, "tx: ");
      printf("error in sending frame\n");
    } else {
      c_internal <: 1;

    }
    c_internal :> int;
  }
}

void printbinln(int x){
  for(unsigned i=0;i<32;i++){
    printint((x>>(31-i))&1);
  }
  printstrln("");
}

void can_rx(chanend c_server, chanend c_master, chanend c_slave) {

  unsigned time;
  can_frame oldest;
  can_frame newest;
  can_frame frm;
  while(1){
    unsigned o_id;
    unsigned n_id;
    unsigned now;
    timer t;

    c_master :> time;
    time += 100000;
    c_master <: time;
    c_slave <: time;

    //both nodes transmit now

    c_slave :> int;
    c_master:> int;

    //recieve both of the frames
    t :> now;
    select {
    	case can_rx_frame(c_server, oldest):{
          break;
    	}
    	case t when timerafter (now+100000000):> now:{
    	  printstrln("bad rx of dominant frame");
    	  _Exit(1);
  		  break;
    	}
    }
    t :> now;
    select {
    	case can_rx_frame(c_server, newest):{
    		break;
    	}
    	case t when timerafter (now+1000000000):> int:{
    	  printstrln("bad rx of recessive frame");
    	  _Exit(1);
  		  break;
    	}
    }
    if(can_rx_entries(c_server)){
  	  printstrln("recieved too many frames");
  	  _Exit(1);
    }
    o_id = oldest.id;
    n_id = newest.id;

      if(oldest.extended + newest.extended == 2){
        if(o_id&(1<<(31-clz(o_id^n_id)))){
            printstrln("incorrect order");
            _Exit(1);
        }
      } else {
        if(oldest.extended)
          o_id = o_id>>18;
        if(newest.extended)
          n_id = n_id>>18;
        if(o_id&(1<<(31-clz((o_id^n_id))))){
            printstrln("incorrect order");
            _Exit(1);
        }
      }
    c_slave <: 1;
    c_master <: 1;
  }
}

void xscope_user_init(void) {
  xscope_register(0, 0, "", 0, "");
  xscope_config_io(XSCOPE_IO_BASIC);
}

int main() {
  chan c_app_0;
  chan c_app_1;
  chan c_app_3;
  chan c_master;
  chan c_slave;
  par {
    on tile[0]: can_tx(c_app_0, c_master, 1, 0x12345678);
    on tile[0]: can_tx(c_app_1, c_slave,  0, 0x87654321);
    on tile[0]: {
      spare_0 <: 0;
      p_0.tx <: 1;
      can_server(p_0, c_app_0);
    }
    on tile[0]: {
      spare_1 <: 0;
      p_1.tx <: 1;
      can_server(p_1, c_app_1);
    }
    on tile[0]: par(int i=0;i<4;i++)while (1);
    on tile[1]: can_rx(c_app_3, c_master, c_slave);
    on tile[1]: {
      spare_3 <: 0;
      p_3.tx <: 1;
      can_server(p_3, c_app_3);
    }
    on tile[1]: par(int i=0;i<6;i++)while (1);
  }
  return 0;
}
