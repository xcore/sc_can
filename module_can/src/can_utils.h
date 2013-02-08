#ifndef CAN_UTILS_H_
#define CAN_UTILS_H_

#include <print.h>

static unsigned super_pattern(unsigned &m) {
  crc32(m, 0xf, 0x82F63B78);
  return m;
}

static void can_utils_print_frame(can_frame f, char prepend[]){
  printstr(prepend);
  printhex(f.id);
  printstr("\t");
  if(f.extended)
    printstr(" : Ext\t");
  else
    printstr(" : Std\t");
  if(f.remote)
    printstr(" : R \t");
  else
    printstr(" : D \t");
  printint(f.dlc);
  printstr("\t");
  if(!f.remote)
    for(unsigned i=0;i<f.dlc;i++){
      printhex(f.data[i]);
      printstr("\t");
    }
  printstrln("");
}
static void can_utils_make_random_frame(can_frame &f, unsigned &x){
  f.extended = super_pattern(x)&1;
  f.remote = super_pattern(x)&1;
  f.dlc = super_pattern(x)%8;
  if(!f.remote)
    for(unsigned i=0;i<f.dlc;i++)
      f.data[i] = super_pattern(x)&0xff;
  if(f.extended)
    f.id = super_pattern(x)&0x3ffff;
  else
    f.
    id = super_pattern(x)&0x7ff;
}

static int can_utils_equal(can_frame &a, can_frame &b) {
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
#endif /* CAN_UTILS_H_ */
