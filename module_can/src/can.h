#ifndef CAN_H_
#define CAN_H_
#include <xs1.h>
#include "can_conf.h"
#include "mutual_thread_comm.h"

#ifndef CAN_FRAME_BUFFER_SIZE
#define CAN_FRAME_BUFFER_SIZE 16.
#endif

#ifndef CAN_MAX_FILTER_SIZE
#define CAN_MAX_FILTER_SIZE 4.
#endif

//CAN status defines
#define CAN_STATE_ACTIVE          (0)
#define CAN_STATE_PASSIVE         (1)
#define CAN_STATE_BUS_OFF         (2)

//Return values
#define CAN_FILTER_ADD_SUCCESS    (0)
#define CAN_FILTER_ADD_FAIL       (1)

#define CAN_FILTER_REMOVE_SUCCESS (0)
#define CAN_FILTER_REMOVE_FAIL    (1)

#define CAN_TX_SUCCESS            (0)
#define CAN_TX_FAIL               (1)

#define CAN_RX_SUCCESS            (0)
#define CAN_RX_FAIL               (1)

typedef struct can_frame {
  unsigned remote;   //true for remote
  unsigned extended; //true for extended
  unsigned id;
  unsigned dlc;
  char data[8];
} can_frame;

#ifdef __XC__
typedef struct can_ports {
  out port tx;
  in buffered port:32 rx;
  clock cb;
} can_ports;
#endif
typedef enum {
  TX_FRAME        = 0,
  TX_FRAME_NB     = 1,
  ADD_FILTER      = 2,
  REMOVE_FILTER   = 3,
  GET_STATUS      = 4,
  RESET           = 5,
  PEEK_LATEST     = 6,
  RX_BUF_ENTRIES  = 7,
  RX_FRAME        = 8
} CAN_COMMANDS;

#ifdef __XC__
/**
 * This is the CAN Bus server.
 *
 * /param can_ports The ports used for CAN RX and CAN TX.
 * /param c_client The chanend connecting the server to the client of the CAN Bus server.
 */
void can_server(struct can_ports &p, chanend server);

/**
 * Take the oldest frame from the RX buffer. If it is empty then it will block until a frame is avaliable.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /param frm A CAN Bus frame passed by reference.
 */
#pragma select handler
void can_rx_frame(chanend c_can_server, can_frame &frm);

/**
 * Send a CAN Bus frame. This function will block until the frame has been successfully
 * sent or the server becomes 'BUS OFF'.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /param frm A CAN Bus frame to be transmitted when the bus is free.
 * /return CAN_TX_SUCCESS or CAN_TX_FAIL.
 */
int can_send_frame(chanend c_can_server, const can_frame &frm);

/**
 * Send a CAN Bus frame. This function does not wait for an acknoledgement of transmission.
 * If a send command is send before this has completed then it will cause the client to
 * block.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /param frm A CAN Bus frame to be transmitted when the bus is free.
 */
void can_send_frame_nonblocking(chanend c_can_server, const can_frame &frm);

/**
 * This resets the transciever to the state it would be when first switched on.
 * All error counter are reset, status is set to 'ACTIVE' and the rx buffer is
 * cleared.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 */
void can_reset(chanend c_can_server);

/**
 * Presents the latest received frame to the client without removing it from the
 * internal FIFO of the CAN Bus server.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /return Returns the number of frames that are currently in the buffer.
 */
int can_peek_latest(chanend c_can_server, can_frame &frm);

/**
 * This returns the status of the CAN Bus server. Can be in state  CAN_STATE_ACTIVE,
 * CAN_STATE_PASSIVE or CAN_STATE_BUS_OFF.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /return The state of the server.
 */
unsigned can_get_status(chanend c_can_server);

/**
 * This adds a filter to the CAN transiever. The filter will reject any frames with
 * id's matching any of its entries.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /param id The id to be added to the frame filter.
 * /return CAN_FILTER_ADD_SUCCESS or CAN_FILTER_ADD_FAIL.
 */
unsigned can_add_filter(chanend c_can_server, unsigned id);

/**
 * This removed a filter from the CAN transiever.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /param id The id to be removed from the frame filter.
 * /return CAN_FILTER_REMOVE_SUCCESS or CAN_FILTER_REMOVE_FAIL.
 */
unsigned can_remove_filter(chanend c_can_server, unsigned id);

/**
 * Used for finding the number of frames currently in the RX buffer.
 *
 * /param c_can_server The chanend connecting the client to the CAN Bus server.
 * /return The count of frames in the RX buffer.
 */
unsigned can_rx_entries(chanend c_can_server);
#endif
#endif /* CAN_H_ */
