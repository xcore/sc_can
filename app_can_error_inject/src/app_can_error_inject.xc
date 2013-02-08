#include <platform.h>
#include "can.h"
#include "can_utils.h"
#include <print.h>
#include <xscope.h>
#include <stdio.h>
#include <stdlib.h>
#include <xclib.h>

on tile[0]: can_ports p_0 = { XS1_PORT_1F, XS1_PORT_1G, XS1_CLKBLK_1 };//star
on tile[0]: can_ports p_1 = { XS1_PORT_1L, XS1_PORT_1I, XS1_CLKBLK_2 };//triangle
on tile[1]: can_ports p_2 = { XS1_PORT_1F, XS1_PORT_1G, XS1_CLKBLK_1 };//square
on tile[1]: can_ports p_3 = { XS1_PORT_1L, XS1_PORT_1I, XS1_CLKBLK_2 };//circle

on tile[0]: port spare_0 = XS1_PORT_4A;
on tile[0]: port spare_1 = XS1_PORT_4E;
on tile[1]: port spare_2 = XS1_PORT_4A;
on tile[1]: port spare_3 = XS1_PORT_4E;

const unsigned size[2] = { 0x800, 0x20000000 };

void seq_tx(chanend c_server, chanend c_internal) {
  can_frame frm;
  timer t;
  unsigned now;
  unsigned j = 0;
  unsigned count =0;
  unsigned restarts = 0;
  for (unsigned extended = 0; extended < 2; extended++) {
    frm.extended = extended;
    for (unsigned dlc = 0; dlc < 9; dlc++) {
      frm.dlc = dlc;
      for (unsigned remote = 0; remote < 2; remote++) {
        frm.remote = remote;
        if (!remote) {
          for (unsigned i = 0; i < dlc; i++)
            frm.data[i] = j++;
        }
        for (unsigned id = 0; id < size[extended]; id++) {
          frm.id = id;

          while(can_send_frame(c_server, frm)==CAN_TX_FAIL){
            printstrln("restart");
            can_reset(c_server);
            restarts++;
          }
          count++;
          t when timerafter(now+100000):> now;
          c_internal <: 1;
          c_internal :> int;

          if(id == size[0]*2)
            id = size[1] - size[0]; //skip to close to the end
        }
      }
    }
  }
  t:> now;
  t when timerafter(now+1000000):> int;
  printstr("sent: ");
  printintln(count);
  printstr("restarts: ");
  printintln(restarts);
}

void seq_rx(chanend c_server, chanend c_internal) {
  can_frame frm;
  can_frame f;
  can_frame last_frame;
  unsigned j = 0;
  unsigned count =0;
  unsigned double_frame=0;
  can_reset(c_server);
  for (unsigned extended = 0; extended < 2; extended++) {
    frm.extended = extended;
    for (unsigned dlc = 0; dlc < 9; dlc++) {
      frm.dlc = dlc;
      for (unsigned remote = 0; remote < 2; remote++) {
        frm.remote = remote;
        if (!remote) {
          for (unsigned i = 0; i < dlc; i++)
            frm.data[i] = j++;
        }
        for (unsigned id = 0; id < size[extended]; id++) {
          unsigned repeat = 1;
          frm.id = id;
          c_internal :> int;

          while(repeat){
            unsigned then, now;
            unsigned panic = 0, done = 0;
            timer T;
            T:> then;
            repeat = 0;
            while(!done){
				#pragma ordered
				select {
					case can_rx_frame(c_server, f):{
						T:> now;
						if(now-then > 0x3fffffff){
							printint(count);printstr(" \t");
							can_utils_print_frame(frm, "");
							panic=1;

					  }
					  break;
					}
					default:
						done = 1;
						break;
				}
            }
            if(panic) break;
            if (!can_utils_equal(f, frm)) {
              if(can_utils_equal(last_frame, f)){
                repeat = 1;
                double_frame++;
              } else {
                printstr("expected: ");
                can_utils_print_frame(frm, "");
                printstr("recieved: ");
                can_utils_print_frame(f, "");
                printstr("last_frame: ");
                can_utils_print_frame(last_frame, "");
                printf("error in recieving frame\n");
                _Exit(1);
              }
            }
          }
          count++;
          last_frame = f;
          c_internal <: 1;
          if(id == size[0]*2)
            id = size[1] - size[0]; //skip to close to the end
        }
      }
    }
  }
  printstrln("rx test complete");
  printstr("got: ");
  printintln(count);
  printstr("double frames: ");
  printintln(double_frame);
}

void can_random_error(can_ports &p){
  timer t;
  unsigned now, x=1;
  t :> now;
  while(1){
    now += (super_pattern(x)>>9) + 50*CAN_CLOCK_DIVIDE;
    t when timerafter(now) :> now;
    p.tx <: 0;
    now += 50*CAN_CLOCK_DIVIDE;
    t when timerafter(now) :> now;
    p.tx <: 1;
  }
}

void xscope_user_init(void) {
  xscope_register(0, 0, "", 0, "");
  xscope_config_io(XSCOPE_IO_BASIC);
}

int main() {
  chan c_app_0;
  chan c_app_1;
  chan c_int;
  par {
    on tile[0]: {
      while(1)seq_tx(c_app_0, c_int);
    }
    on tile[0]: {
      while(1)seq_rx(c_app_1, c_int);
    }
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
    on tile[1]: {
      spare_3 <: 0;
      p_3.tx <: 1;
      can_random_error(p_3);
    }
    on tile[1]: par(int i=0;i<7;i++)while (1);
  }
  return 0;
}
