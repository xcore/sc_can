#ifndef DEBUG_H_
#define DEBUG_H_

#include <print.h>

void report_error(int i){
  switch(i){
  case ERROR_BIT_ERROR: {
    printstrln("Bit error");
    break;
  }
  case ERROR_STUFF_ERROR: {
    printstrln("Stuff error");
    break;
  }
  case ERROR_FORM_ERROR: {
    printstrln("Form error");
    break;
  }
  case ERROR_CRC_ERROR: {
    printstrln("CRC error");
    break;
  }
  case ERROR_NO_ACK: {
    printstrln("No ack error");
    break;
  }
  case ERROR_SPECIAL_STUFF_ERROR: {
    printstrln("Special Stuff error");
    break;
  }
  default:
    printintln(i);
    break;
  }
}

void print_rxtx(RxTxFrame f){
  unsigned dlc;
  printstr("rx_id_std: ");
  printhexln(f.rx_id_std);
  printstr("rx_id_ext: ");
  printhexln(f.rx_id_ext);

  if(f.rx_extended){
   printstr("Extended : ");
  } else {
   printstr("Standard : ");
  }
  if(f.rx_remote){
   printstrln("Remote : ");
  } else {
   printstrln("Data   : ");
  }
  printstr("DLC: ");
  dlc = f.rx_dlc;

  printhexln(dlc);
  if(!f.rx_remote){
   for(unsigned i=0;i<dlc;i++){
     printint(i);
     printstr(" ");
     printhex((f.rx_DATA, char [])[i]);
     printstr("(");
     printint((f.rx_DATA, char [])[i]);
     printstrln(")");
   }
  }
}

static void print_frame(can_frame f){
  printstr("Frame id: ");
  printhex(f.id);
  printstr("(");
  printint(f.id);
  printstrln(")");

  if(f.extended){
    printstrln("Extended");
  } else {
    printstrln("Standard");
  }
  if(f.remote){
    printstrln("Remote");
  } else {
    printstrln("Data");
  }
  printstr("DLC: ");
  printintln(f.dlc);
  if(!f.remote){
    for(unsigned i=0;i<f.dlc;i++){
      printint(i);
      printstr(" ");
      printhex(f.data[i]);
      printstr("(");
      printint(f.data[i]);
      printstrln(")");
    }
  }
  printstrln("---------------------");
}

static int equal(can_frame &a, can_frame &b){
  if(a.id != b.id)
    return 0;
  if(a.extended != b.extended)
    return 0;
  if(a.remote != b.remote)
    return 0;
  if(a.dlc != b.dlc)
    return 0;
  if(!a.remote){
    for(unsigned i=0;i<a.dlc;i++){
      if(a.data[i] != b.data[i])
        return 0;
    }
  }
  return 1;
}

#endif /* DEBUG_H_ */
