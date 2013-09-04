.. _sec_api:

CAN Bus API
===========

.. _sec_conf_defines:

Configuration Defines
---------------------

The file ``can_conf.h`` must be provided in the application source code, and it must define:

PROP_SEG,
PHASE_SEG1,
PHASE_SEG2,
CAN_CLOCK_DIVIDE

in order to describe the CAN Bus that the device is connecting to. It can also be used to override the default values specified in ``can.h``

**CAN_FRAME_BUFFER_SIZE**
   The size of the frame buffer FIFO in number of frames. Note: it will save the last CAN_FRAME_BUFFER_SIZE - 1 frames as one is reserved for the next frame.

**CAN_MAX_FILTER_SIZE**
   The size of the frame filter in number of id's to be filtered.

**CAN_CLOCK_DIVIDE**
   This divides the 1MHz bit clock by 2 times the value set. The value divider on the CAN clock from a 1Mb maximum,   e.g. for 1Mb use a divider of 0, for 500Kb use a divider of 1, etc.

**PROP_SEG**
   The number of TIME QUANTUM for the PROP_SEG. 

**PHASE_SEG1**
   The number of TIME QUANTUM for the PHASE_SEG1. 

**PHASE_SEG2**
   The number of TIME QUANTUM for the PHASE_SEG2. 

Port Config
+++++++++++

The port config is given in ``can.h``. Note that the CAN rx and tx must use one bit ports due to the usage of buffering in the implementation.

CAN Bus API
-----------

These are the functions that are called from the application and are included in ``can.h``.

.. doxygenfunction:: can_server
.. doxygenfunction:: can_send_frame
.. doxygenfunction:: can_send_frame_nonblocking
.. doxygenfunction:: can_reset
.. doxygenfunction:: can_remove_filter
.. doxygenfunction:: can_pop_frame
.. doxygenfunction:: can_get_status
.. doxygenfunction:: can_add_filter

