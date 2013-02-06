#include <platform.h>
#include "can.h"
#include <print.h>
#include <xscope.h>
#include <stdio.h>
#include <stdlib.h>

on tile[0]: can_ports p_0 = { XS1_PORT_1F, XS1_PORT_1G, XS1_CLKBLK_1 };//star
on tile[0]: can_ports p_1 = { XS1_PORT_1L, XS1_PORT_1I, XS1_CLKBLK_2 };//triangle
on tile[1]: can_ports p_2 = { XS1_PORT_1F, XS1_PORT_1G, XS1_CLKBLK_1 };//square
on tile[1]: can_ports p_3 = { XS1_PORT_1L, XS1_PORT_1I, XS1_CLKBLK_2 };//circle

on tile[0]: port spare_0 = XS1_PORT_4A;
on tile[0]: port spare_1 = XS1_PORT_4E;
on tile[1]: port spare_2 = XS1_PORT_4A;
on tile[1]: port spare_3 = XS1_PORT_4E;
unsigned m = 0xffffffff;
const unsigned size[2] = { 0x800, 0x20000000 };

unsigned super_pattern() {
  crc32(m, 0xf, 0x82F63B78);
  return m;
}
static void print_frame(can_frame f) {
  printhex(f.id);
  printstr("\t");
  if (f.extended) {
    printstr(" : Ext\t");
  } else {
    printstr(" : Std\t");
  }
  if (f.remote) {
    printstr(" : R \t");
  } else {
    printstr(" : D \t");
  }

  printint(f.dlc);
  printstr("\t");

  if (!f.remote) {
    for (unsigned i = 0; i < f.dlc; i++) {
      printhex(f.data[i]);
      printstr("\t");
    }
  }
  printstrln("");
}

void make_random_frame(can_frame &f) {
  f.extended = super_pattern() & 1;
  f.remote = super_pattern() & 1;
  f.dlc = super_pattern() % 8;
  if (!f.remote) {
    for (unsigned i = 0; i < f.dlc; i++)
      f.data[i] = super_pattern() & 0xff;
  }
  if (f.extended)
    f.id = super_pattern() & 0x3ffff;
  else
    f.id = super_pattern() & 0x7ff;
}

static int equal(can_frame &a, can_frame &b) {
  if (a.id != b.id)
    return 0;
  if (a.extended != b.extended)
    return 0;
  if (a.remote != b.remote)
    return 0;
  if (a.dlc != b.dlc)
    return 0;
  if (!a.remote) {
    for (unsigned i = 0; i < a.dlc; i++) {
      if (a.data[i] != b.data[i])
        return 0;
    }
  }
  return 1;
}

void seq_tx(chanend c_server, chanend c_internal) {
  can_frame frm;
  timer t;
  unsigned now;
  unsigned i = 0;
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
            print_frame(frm);
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
          if (!equal(f, frm)) {
            printstr("expected: ");
            print_frame(frm);
            printstr("recieved: ");
            print_frame(f);
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

void filter_remove_rx(chanend c_server, chanend c_internal) {
  for(unsigned filters=0;filters<=CAN_MAX_FILTER_SIZE;filters++){
    for(unsigned i=0;i<filters;i++){
      if(can_add_filter(c_server, i)==CAN_FILTER_ADD_FAIL){
        printstrln("filter add fail\n");
         _Exit(1);
      }
      if(can_remove_filter(c_server, i)==CAN_FILTER_REMOVE_FAIL){
        printstrln("filter remove fail\n");
         _Exit(1);
      }
      if(can_remove_filter(c_server, 0)==CAN_FILTER_REMOVE_SUCCESS){
        printstrln("filter list not empty\n");
        _Exit(1);
      }
    }
  }
  for(unsigned filters=0;filters<CAN_MAX_FILTER_SIZE;filters++){
    if(can_add_filter(c_server, filters)==CAN_FILTER_ADD_FAIL){
      printstrln("filter problem\n");
       _Exit(1);
    }
  }
  for(unsigned filters=0;filters<CAN_MAX_FILTER_SIZE;filters++){
    if(can_add_filter(c_server, filters)==CAN_FILTER_ADD_SUCCESS){
      printstrln("filter fail overflow\n");
       _Exit(1);
    }
  }
  for(unsigned filters=0;filters<CAN_MAX_FILTER_SIZE;filters++){
    if(can_remove_filter(c_server, filters)==CAN_FILTER_REMOVE_FAIL){
      printstrln("filter removal fail\n");
       _Exit(1);
    }
  }
  if(can_remove_filter(c_server, 0)==CAN_FILTER_REMOVE_SUCCESS){
    printstrln("filter list not empty\n");
    _Exit(1);
  }
  printstrln("filter remove test complete");
}

void can_tx(chanend c_server, chanend c_internal) {
  seq_tx(c_server, c_internal);
}

void can_rx(chanend c_server, chanend c_internal) {
  seq_rx(c_server, c_internal);
  filter_remove_rx(c_server, c_internal);
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
    on tile[0]: can_tx(c_app_0, c_internal);
    on tile[0]: {
      spare_0 <: 0;
      p_0.tx <: 1;
      can_server(p_0, c_app_0);
    }
    on tile[0]: par(int i=0;i<6;i++)while (1);

    on tile[1]:can_rx(c_app_1, c_internal);
    on tile[1]: {
      spare_3 <: 0;
      p_3.tx <: 1;
      can_server(p_3, c_app_1);
    }
    on tile[1]: par(int i=0;i<6;i++)while (1);
  }
  return 0;
}
