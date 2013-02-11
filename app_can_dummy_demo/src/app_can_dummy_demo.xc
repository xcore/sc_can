#include <platform.h>
#include <xscope.h>
#include "can_dummy.h"
#include "can_dummy_utils.h"

void application(chanend c_rx_tx) {
  timer t;
  unsigned now;
  unsigned seed = 0x12345678;
  t:> now;
  while(1){
	can_frame f;
	int done = 0;
	can_utils_make_random_frame(f, seed);
    can_send_frame(c_rx_tx, f);
    can_utils_print_frame(f, "tx: ");
    while(!done){
	  select {
	    case t when timerafter (now + 500000000) :> now:
          done = 1;
	      break;
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
    on tile[0]: can_server(c_rx_tx);
  }
  return 0;
}
