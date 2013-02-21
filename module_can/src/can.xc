#include "can.h"
#include "can_defines.h"
#include "mutual_thread_comm.h"
#include <xclib.h>

typedef struct RxTxFrame {
  unsigned rx_DATA[2];
  unsigned tx_DATA[2];
  //These are all word aligned as they are accessed via the dp
  unsigned rx_remote;   //true for remote
  unsigned tx_remote;   //true for remote
  unsigned rx_extended; //true for extended
  unsigned tx_extended; //true for extended
  unsigned rx_id_std;
  unsigned tx_id_std;
  unsigned rx_id_ext;
  unsigned tx_id_ext;
  unsigned rx_dlc;
  unsigned tx_dlc;
} RxTxFrame;

//#define DEBUG
#ifdef DEBUG
#include <assert.h>
#include "debug.h"
#endif

#ifndef CAN_CLOCK_DIVIDE
#error CAN_CLOCK_DIVIDE is undefined.
#endif

extern int canRxTxImpl( unsigned tx, unsigned time,
    struct can_ports &p, RxTxFrame &rx_tx_frame, unsigned error_status);

#pragma unsafe arrays
static inline void zeroFrame(RxTxFrame &f){
  f.rx_DATA[0]=0;
  f.rx_DATA[1]=0;
  f.tx_DATA[0]=0;
  f.tx_DATA[1]=0;
  f.rx_remote=0;
  f.tx_remote=0;
  f.rx_extended=0;
  f.tx_extended=0;
  f.rx_id_std=0;
  f.tx_id_std=0;
  f.rx_id_ext=0;
  f.tx_id_ext=0;
  f.rx_dlc=0;
  f.tx_dlc=0;
}

static void init(struct can_ports &p){
  stop_clock(p.cb);
  set_clock_div(p.cb, CAN_CLOCK_DIVIDE);
  set_port_clock(p.tx, p.cb);
  set_port_clock(p.rx, p.cb);
  start_clock(p.cb);
}

//Takes a non-mangled RxTxFrame and mangles it(for the reciever)
#pragma unsafe arrays
static inline void mangle_data(RxTxFrame &f){
  unsigned t = byterev(bitrev(f.tx_DATA[0]));
  unsigned p = byterev(bitrev(f.tx_DATA[1]));
  unsigned dlc = f.tx_dlc;
  f.tx_dlc = (bitrev(dlc) >> 28)&0xf;
  switch(dlc){
  case 0:
    return;
  case 1:
  case 2:
  case 3:
  case 4:
    f.tx_DATA[1] = t;
    break;
  case 5:
    f.tx_DATA[0] = t&0xff;
    f.tx_DATA[1] = (p<<24) | (t>>8);
    break;
  case 6:
    f.tx_DATA[0] = t&0xffff;
    f.tx_DATA[1] = (p<<16) + (t>>16);
    break;
  case 7:
    f.tx_DATA[0] = t&0xffffff;
    f.tx_DATA[1] = (p<<8) + (t>>24);
    break;
  case 8:
    f.tx_DATA[0] = t;
    f.tx_DATA[1] = p;
    break;
  }
}

//Takes a mangled(out of the reciever) RxTxFrame and demangles it.
//Note, mangle and demangle are not symetric.
#pragma unsafe arrays
static inline void demangle_data(RxTxFrame &f){
  unsigned t = byterev(f.rx_DATA[0]);
  unsigned p = byterev(f.rx_DATA[1]);
  switch(f.rx_dlc){
  case 0:
    return;
  case 1:
    f.rx_DATA[0] = p>>24;
    break;
  case 2:
    f.rx_DATA[0] = p>>16;
    break;
  case 3:
    f.rx_DATA[0] = p>>8;
    break;
  case 4:
    f.rx_DATA[0] = p;
    break;
  case 5:
    f.rx_DATA[0] = (t>>24) + (p<<8);
    f.rx_DATA[1] = (p>>24)&0xff;
    break;
  case 6:
    f.rx_DATA[0] = (t>>16) + (p<<16);
    f.rx_DATA[1] = (p>>16)&0xffff;
    break;
  case 7:
    f.rx_DATA[0] = (t>>8) + (p<<24);
    f.rx_DATA[1] = (p>>8)&0xffffff;
    break;
  case 8:
    f.rx_DATA[0] = t;
    f.rx_DATA[1] = p;
    break;
  }
}

#pragma unsafe arrays
static inline void frame_to_rxtx(can_frame &f, RxTxFrame &r){
  unsigned id = bitrev(f.id);
  if(f.extended){
    r.tx_id_std = (id >> 3)&0x7ff;
    r.tx_id_ext = (id >> 14)&0x3ffff;
  } else {
    r.tx_id_std = (id >> 21)&0x7ff;
    r.tx_id_ext = 0;
  }
  r.tx_extended = f.extended;
  r.tx_remote = f.remote;
  r.tx_dlc = f.dlc;
  r.tx_DATA[0] = (f.data, unsigned[])[0];
  r.tx_DATA[1] = (f.data, unsigned[])[1];
}

#pragma unsafe arrays
static inline void rxtx_to_frame(can_frame &f, RxTxFrame &r){
  f.extended = r.rx_extended;
  f.dlc = r.rx_dlc;
  f.remote = r.rx_remote;
  if(f.extended){
    f.id = (r.rx_id_std << 18) | r.rx_id_ext;
  } else {
    f.id = r.rx_id_std;
  }
  (f.data, unsigned[])[0] = r.rx_DATA[0];
  (f.data, unsigned[])[1] = r.rx_DATA[1];
}

static void adjust_successful_receive_error_counter(unsigned &receive_error_counter){
  if(receive_error_counter > 0){
    if(receive_error_counter < 128)
      receive_error_counter--;
    else
      receive_error_counter = 127;
  }
}

//This is far from the spec and could do with a lot of improvement
static void send_active_error(struct can_ports &p){
  unsigned error_start;
  unsigned release_flag;
  p.tx <: 0 @ error_start;
  error_start += 50 * 6;
  p.tx <: 1 @ error_start;
  p.rx when pinseq(1) :> unsigned @ release_flag;
}

static void adjust_status(unsigned &error_status, unsigned transmit_error_counter,
    unsigned receive_error_counter, struct can_ports &p){

  if(transmit_error_counter > 127){
    if(transmit_error_counter > 255){
      error_status = CAN_STATE_BUS_OFF;
    } else {
      error_status = CAN_STATE_PASSIVE;
      send_active_error(p);
    }
  } else if(receive_error_counter > 127){
    error_status = CAN_STATE_PASSIVE;
    send_active_error(p);
  } else {
    error_status = CAN_STATE_ACTIVE;
  }
}

#pragma unsafe arrays
static int reject_message(unsigned message_filters[CAN_MAX_FILTER_SIZE],
    unsigned message_filter_count, unsigned id){
  for(unsigned i=0;i<message_filter_count;i++){
    if(message_filters[i] == id)
      return 1;
  }
  return 0;
}

static int rx_success(RxTxFrame &r, can_frame rx_buf[CAN_FRAME_BUFFER_SIZE],
		unsigned &buffer_head, unsigned &buffer_tail, unsigned message_filters[CAN_MAX_FILTER_SIZE], unsigned message_filter_count,
    unsigned &receive_error_counter){
  unsigned buf_head_index = buffer_head % CAN_FRAME_BUFFER_SIZE;
  can_frame f = rx_buf[buf_head_index];
  demangle_data(r);
  rxtx_to_frame(rx_buf[buf_head_index], r);
  adjust_successful_receive_error_counter(receive_error_counter);
  if(CAN_MAX_FILTER_SIZE){
    if(!reject_message(message_filters, message_filter_count, rx_buf[buf_head_index].id)){
      buffer_head++;
      return CAN_RX_SUCCESS;
    }
    return CAN_RX_FAIL;
  } else {
    buffer_head++;
    return CAN_RX_SUCCESS;
  }

}

#pragma unsafe arrays
void can_server(struct can_ports &p, chanend server){
  can_frame rx_buf[CAN_FRAME_BUFFER_SIZE];

  unsigned message_filters[CAN_MAX_FILTER_SIZE];
  unsigned message_filter_count = 0;

  unsigned buffer_head = 0;
  unsigned buffer_tail = 0;

  unsigned error_status = CAN_STATE_ACTIVE;
  unsigned receive_error_counter = 0;
  unsigned transmit_error_counter = 0;

  unsigned char cmd = 0;
  unsigned time;

  RxTxFrame r;

  unsigned tx_enabled = 1;
  unsigned tx_back_on;
  timer bit_timer;

  mutual_comm_state_t mstate;
  int is_response_to_notification;
  mutual_comm_init_state(mstate);

  init(p);
  zeroFrame(r);

  while(1){
    #pragma ordered
    select {
#pragma xta endpoint "rx_begin"
      case p.rx when pinseq(error_status == CAN_STATE_BUS_OFF) :> int @ time: {
        if(error_status == CAN_STATE_BUS_OFF){
#pragma xta label "bus_off"
          unsigned val;
          timer t;
          unsigned time;
          t :> time;
          select {
            case p.rx when pinseq(0) :> unsigned:
            break;
            case t when timerafter(time + 128*11*CAN_CLOCK_DIVIDE*100) :> time:
            error_status = CAN_STATE_ACTIVE;
            transmit_error_counter = 0;
            receive_error_counter = 0;
            break;
          }
        } else {
          int e = canRxTxImpl(0, time, p, r, error_status);
          bit_timer :> tx_back_on;
          tx_back_on += 3*CAN_CLOCK_DIVIDE*2*50;
          tx_enabled = 0;
          if (RXTX_RET_TO_ERROR_TYPE(e) == CAN_ERROR_RX_NONE) {
        	  int rx_succ = rx_success(r, rx_buf, buffer_head, buffer_tail, message_filters,
        			  message_filter_count, receive_error_counter);
        	  if(rx_succ == CAN_RX_SUCCESS)
        		  mutual_comm_notify(server, mstate);
          } else {
            receive_error_counter += RXTX_RET_TO_ERROR_COUNTER(e);
          }
          zeroFrame(r);
          break;
        }
        break;
      }

      case !tx_enabled => bit_timer when timerafter(tx_back_on) :> int :{
        tx_enabled = 1;
        break;
      }

#pragma xta endpoint "tx_begin"

      case mutual_comm_transaction(server, is_response_to_notification, mstate):{
    	  if (is_response_to_notification) {
    		  unsigned count = (buffer_head - buffer_tail);
          unsigned buf_tail_index;
          if(count > CAN_FRAME_BUFFER_SIZE)
            buffer_tail = buffer_head - CAN_FRAME_BUFFER_SIZE;
#ifdef DEBUG
          assert(count);
#endif
          buf_tail_index = buffer_tail%CAN_FRAME_BUFFER_SIZE;
          slave {
            server <: rx_buf[buf_tail_index].remote;
            server <: rx_buf[buf_tail_index].extended;
            server <: rx_buf[buf_tail_index].id;
            server <: rx_buf[buf_tail_index].dlc;
            server <: (rx_buf[buf_tail_index].data, unsigned[])[0];
            server <: (rx_buf[buf_tail_index].data, unsigned[])[1];
          }
          buffer_tail++;

          mutual_comm_complete_transaction(server,
                          is_response_to_notification,
                          mstate);
          if(count>1)
            mutual_comm_notify(server, mstate);
      } else {
        int e;
        int rx_succ = CAN_RX_FAIL;
        server :> cmd;
        switch(cmd){
        case TX_FRAME:
        case TX_FRAME_NB:{
          int sent = 0;
          can_frame f;
          slave {
            server :> f.remote;
            server :> f.extended;
            server :> f.id;
            server :> f.dlc;
            server :> (f.data, unsigned[])[0];
            server :> (f.data, unsigned[])[1];
          }
          if(error_status == CAN_STATE_BUS_OFF){
            if(cmd == TX_FRAME)
              server <: CAN_TX_FAIL;
            continue;
          }

          while(!sent){
            frame_to_rxtx(f, r);
            mangle_data(r);
            if(tx_enabled){
              e = canRxTxImpl(1, 0, p, r, error_status);
              bit_timer :> tx_back_on;
            } else {
              select {
                case p.rx when pinseq(0) :> int @ time: {
                  e = canRxTxImpl(0, time, p, r, error_status);
                  bit_timer :> tx_back_on;
                  break;
                }
                case bit_timer when timerafter(tx_back_on) :> int :{
                  e = canRxTxImpl(1, 0, p, r, error_status);
                  bit_timer :> tx_back_on;
                break;
                }
              }
            }
            tx_back_on += 3*CAN_CLOCK_DIVIDE*2*50;
            tx_enabled = 0;

            switch(RXTX_RET_TO_ERROR_TYPE(e)){
            case CAN_ERROR_TX_NONE:{
              if(transmit_error_counter)
                transmit_error_counter--;
              sent = 1;
              if(cmd == TX_FRAME)
                server <: CAN_TX_SUCCESS;
              if(error_status == CAN_STATE_PASSIVE)
                tx_back_on += 8*CAN_CLOCK_DIVIDE*2*50;
              break;
            }
            case CAN_ERROR_RX_NONE:{
              rx_succ = rx_success(r, rx_buf, buffer_head, buffer_tail, message_filters,
                message_filter_count, receive_error_counter);
              break;
            }
            case CAN_ERROR_TX_ERROR:{
              transmit_error_counter += RXTX_RET_TO_ERROR_COUNTER(e);
              if(error_status == CAN_STATE_PASSIVE)
                tx_back_on += 8*CAN_CLOCK_DIVIDE*2*50;
              break;
            }
            case CAN_ERROR_RX_ERROR:{
              receive_error_counter += RXTX_RET_TO_ERROR_COUNTER(e);
              break;
            }
            }
            zeroFrame(r);
            adjust_status(error_status, transmit_error_counter, receive_error_counter, p);
            if(error_status == CAN_STATE_BUS_OFF){
              if(cmd == TX_FRAME)
                server <: CAN_TX_FAIL;
              break;
            }
          }
          break;
        }
        case PEEK_LATEST:{
          unsigned count = (buffer_head - buffer_tail);
          unsigned buf_head_index;
          if(count > CAN_FRAME_BUFFER_SIZE)
            buffer_tail = buffer_head - CAN_FRAME_BUFFER_SIZE;
          buf_head_index = buffer_head%CAN_FRAME_BUFFER_SIZE;
          server <: count;
          if(count){
            slave {
            server <: rx_buf[buf_head_index].remote;
            server <: rx_buf[buf_head_index].extended;
            server <: rx_buf[buf_head_index].id;
            server <: rx_buf[buf_head_index].dlc;
            server <: (rx_buf[buf_head_index].data, unsigned[])[0];
            server <: (rx_buf[buf_head_index].data, unsigned[])[1];
            }
          }
          break;
        }
        case RX_BUF_ENTRIES:{
          unsigned count = (buffer_head - buffer_tail);
          if(count > CAN_FRAME_BUFFER_SIZE)
            buffer_tail = buffer_head - CAN_FRAME_BUFFER_SIZE;
          count = (buffer_head - buffer_tail);
          server <: count;
          break;
        }
        case ADD_FILTER:{
          unsigned filter_id;
          server :> filter_id;
          if(message_filter_count < CAN_MAX_FILTER_SIZE){
            message_filters[message_filter_count] = filter_id;
            message_filter_count++;
            server <: CAN_FILTER_ADD_SUCCESS;
          } else {
            server <: CAN_FILTER_ADD_FAIL;
          }
          break;
        }
        case REMOVE_FILTER:{
          unsigned filter_id;
          unsigned index=0;
          unsigned found=0;
          server :> filter_id;
          for(index=0;index<message_filter_count;index++){
            if(message_filters[index] == filter_id){
              found = 1;
              break;
            }
          }

          if(found){
            for(unsigned i=index;i<message_filter_count;i++){
              if(i+1<CAN_MAX_FILTER_SIZE)
                message_filters[i] = message_filters[i+1];
            }
            message_filter_count--;
            server <: CAN_FILTER_REMOVE_SUCCESS;
          } else {
            server <: CAN_FILTER_REMOVE_FAIL;
          }

          break;
        }
        case GET_STATUS:{
          server <: error_status;
          break;
        }
        case RESET:{
          int is_data_request;
          mutual_comm_complete_transaction(server, is_data_request, mstate);
          // At this point the notification flag may or may not be set.
          // Set the notification flag so that the client can unconditionally
          // call mutual_comm_notified() to clear the flag without blocking.
          mutual_comm_notify(server, mstate);
          mutual_comm_transaction(server, is_data_request, mstate);
#ifdef DEBUG
          assert(!is_data_request);
#endif
          mutual_comm_complete_transaction(server, is_data_request, mstate);
          error_status = CAN_STATE_ACTIVE;
          transmit_error_counter = 0;
          receive_error_counter = 0;
          buffer_head = 0;
          buffer_tail = 0;
          message_filter_count=0;
          tx_enabled = 1;
          break;
        }
        }
        mutual_comm_complete_transaction(server,
 										  is_response_to_notification,
 										  mstate);
        if(rx_succ == CAN_RX_SUCCESS)
          mutual_comm_notify(server, mstate);
        }


		  break;
      }
    }
  }
}
