#ifndef CAN_UTILS_H_
#define CAN_UTILS_H_

unsigned m = 0xffffffff;

static unsigned super_pattern() {
  crc32(m, 0xf, 0x82F63B78);
  return m;
}

static void can_utils_print_frame(can_frame f){
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
static void can_utils_make_random_frame(can_frame &f){
  f.extended = super_pattern()&1;
  f.remote = super_pattern()&1;
  f.dlc = super_pattern()%8;
  if(!f.remote)
    for(unsigned i=0;i<f.dlc;i++)
      f.data[i] = super_pattern()&0xff;
  if(f.extended)
    f.id = super_pattern()&0x3ffff;
  else
    f.id = super_pattern()&0x7ff;
}

#endif /* CAN_UTILS_H_ */
