#include <platform.h>
#include <xscope.h>
#include "can.h"
#include "can_utils.h"
on tile[0]: can_ports p = { XS1_PORT_1L, XS1_PORT_1I, XS1_CLKBLK_1 };
on tile[0]: port shutdown = XS1_PORT_4E;

void application(chanend c_rx_tx) {
  timer t;
  unsigned now, seed = 0x12345678;
  t:> now;
  while(1){
	  can_frame f;
	  int done = 0;
	  can_utils_make_random_frame(f, seed);
    can_send_frame(c_rx_tx, f);
    can_utils_print_frame(f, "tx: ");
    while(!done){
      select {
	      //wait for half a second
	      case t when timerafter (now + 50000000) :> now:
          done = 1;
	      break;
	      //or report any frames received
	      case can_rx_frame(c_rx_tx, f):{
		      can_utils_print_frame(f, "rx: ");
		    break;
	      }
	    }
    }
  }
}

void xscope_user_init(void) {
  xscope_register(0, 0, "", 0, "");
  xscope_config_io(XSCOPE_IO_BASIC);
}

int main() {
  chan c_rx_tx;
  par {
    on tile[0]: application(c_rx_tx);
    on tile[0]: {
      shutdown <: 0;
      can_server(p, c_rx_tx);
    }
  }
  return 0;
}
