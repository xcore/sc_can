#include <platform.h>
#include <xscope.h>
#include <print.h>
#include "can.h"
#include "can_utils.h"
on tile[0]: can_ports p = { XS1_PORT_1F, XS1_PORT_1G, XS1_CLKBLK_1 };
on tile[0]: port shutdown = XS1_PORT_4A;

void application(chanend c_rx_tx) {
  timer t;
  unsigned now, done = 0;
  can_frame f;
  t:> now;
  while(1){
	  can_utils_make_random_frame(f);
    can_send_frame(c_rx_tx, f);
    printstr("tx:");
    can_utils_print_frame(f);
    done = 0;
    while(!done){
      select {
        case t when timerafter (now + 500000000) :> now:
          done = 1;
          break;
        default:
          if(can_pop_frame(c_rx_tx, f)!=-1){
            printstr("rx:");
            can_utils_print_frame(f);
          }
          break;
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
    on tile[0]: par(int i=0;i<6;i++) while(1);
  }
  return 0;
}
