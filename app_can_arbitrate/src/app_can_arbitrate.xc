#include <platform.h>
#include "can.h"
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

void can_tx(chanend c_server, chanend c_internal, int master_node) {
  can_frame frm;
  timer t;
  unsigned now;
  while(1){

    make_random_frame(frm);
    if(master_node){
      frm.id = (frm.id+master_node)&(size[frm.extended]-1);
    }

    if(master_node){
      t:> now;
      c_internal <: now;
    }
    c_internal :> now;
    t when timerafter(now):> int;

    if (can_send_frame(c_server, frm)) {
      print_frame(frm);
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
    unsigned t;

    c_master :> time;
    time += 100000;
    c_master <: time;
    c_slave <: time;

    c_slave :> int;
    c_master:> int;
/*
  //FIXME
    if (can_pop_frame(c_server, oldest) == -1) {
      printstrln("bad rx of dominant frame");
      _Exit(1);
    }
    if (can_pop_frame(c_server, newest) == -1) {
      printstrln("bad rx of recessive frame");
      _Exit(1);
    }

    if (can_pop_frame(c_server, frm) != -1) {
      printstrln("too much in rx buffer");
      _Exit(1);
    }
*/
    o_id = oldest.id;
    n_id = newest.id;

      if(oldest.extended + newest.extended == 2){
        t = clz(o_id^n_id);
        if(o_id&(1<<(31-t))){
            printstrln("incorrect order");
            _Exit(1);
        }
      } else {
        if(oldest.extended)
          o_id = o_id>>18;
        if(newest.extended)
          n_id = n_id>>18;
        t = clz((o_id^n_id));
        if(o_id&(1<<(31-t))){
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
    on tile[0]: can_tx(c_app_0, c_master, 1);
    on tile[0]: can_tx(c_app_1, c_slave, 0);
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
