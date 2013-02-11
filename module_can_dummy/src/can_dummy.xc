#include "can_dummy.h"
#include "can_dummy_utils.h"
#include "mutual_thread_comm.h"
#include <xclib.h>
#include <stdlib.h>
#include <assert.h>

#pragma unsafe arrays
void can_server(chanend server){
  can_frame rx_buf[CAN_FRAME_BUFFER_SIZE];

  unsigned buffer_head = 0;
  unsigned buffer_tail = 0;

  unsigned char cmd = 0;

  timer t;
  unsigned time;
  unsigned seed = 1;

  mutual_comm_state_t mstate;
  int is_response_to_notification;
  mutual_comm_init_state(mstate);

  while(1){
    #pragma ordered
    select {
	    case t when timerafter(time+100000000) :> time:{
        unsigned buf_head_index = buffer_head % CAN_FRAME_BUFFER_SIZE;
        can_utils_make_random_frame(rx_buf[buf_head_index], seed);
        buffer_head++;
        mutual_comm_notify(server, mstate);
        break;
	    }

	    case mutual_comm_transaction(server, is_response_to_notification, mstate):{
        if (is_response_to_notification) {
          unsigned count = (buffer_head - buffer_tail);
          unsigned buf_tail_index;
          if(count > CAN_FRAME_BUFFER_SIZE)
          buffer_tail = buffer_head - CAN_FRAME_BUFFER_SIZE;
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
          server :> cmd;
          switch(cmd){
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
          }
          mutual_comm_complete_transaction(server, is_response_to_notification, mstate);
          mutual_comm_notify(server, mstate);
        }
        break;
	    }
    }
  }
}
