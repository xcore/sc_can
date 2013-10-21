#include <platform.h>
#include <print.h>
#include <xscope.h>
#include <stdio.h>
#include <stdlib.h>
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

void seq_tx(chanend c_server, chanend c_internal) {
  can_frame frm;
  unsigned j = 0;
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
          if (can_send_frame(c_server, frm)) {
        	can_utils_print_frame(frm, "");
            printf("error in sending frame\n");
          } else {
            c_internal <: 1;
          }
          c_internal :> int;

          if(id == size[0]*2)
            id = size[1] - size[0]; //skip to close to the end
        }
      }
    }
  }
}

void seq_rx(chanend c_server, chanend c_internal) {
  can_frame frm;
  can_frame f;
  unsigned j = 0;
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
          frm.id = id;
          c_internal :> int;
          can_rx_frame(c_server, f);
          if (!can_utils_equal(f, frm)) {
            printstr("expected: ");
            can_utils_print_frame(frm, "");
            printstr("recieved: ");
            can_utils_print_frame(f, "");
            printf("error in recieving frame\n");
            _Exit(1);
          }
          if(id == size[0]*2)
            id = size[1] - size[0]; //skip to close to the end
          c_internal <: 1;
        }
      }
    }
  }
  printstrln("rx test complete");
}

void xscope_user_init(void) {
  xscope_register(0, 0, "", 0, "");
  xscope_config_io(XSCOPE_IO_BASIC);
}

int main() {
  chan c_app_0;
  chan c_app_1;
  chan c_internal;
  par {
    on tile[0]: seq_tx(c_app_0, c_internal);
    on tile[0]: {
      spare_0 <: 0;
      p_0.tx <: 1;
      can_server(p_0, c_app_0);
    }
    on tile[0]: par(int i=0;i<6;i++)while (1);
    on tile[1]:seq_rx(c_app_1, c_internal);
    on tile[1]: {
      spare_3 <: 0;
      p_3.tx <: 1;
      can_server(p_3, c_app_1);
    }
    on tile[1]: par(int i=0;i<6;i++)while (1);
  }
  return 0;
}
