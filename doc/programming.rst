
CAN Bus Programming Guide
=========================

This section provides information on how to program applications using the CAN Bus module.

Source code structure
---------------------

Directory Structure
+++++++++++++++++++

A typical CAN Bus application will have at least two top level directories. The application will be contained in a directory starting with ``app_``, the CAN Bus module source is in the ``module_can`` directory and the directory ``module_xcommon`` contains files required to build the application. ::
    
    app_[my_app_name]/
    module_can/
    module_xcommon/

Of course the application may use other modules which can also be directories at this level. Which modules are compiled into the application is controlled by the ``USED_MODULES`` define in the application Makefile.

Key Files
+++++++++

The following header file contains prototypes of all functions required to use the CAN Bus 
module. The API is described in :ref:`sec_api`.

.. list-table:: Key Files
  :header-rows: 1

  * - File
    - Description
  * - ``can.h``
    - CAN Bus API header file

Module Usage
------------

To use the CAN Bus module first set up the directory structure as shown above. Create a file in the ``app`` folder called ``can_conf.h`` and into it insert a define for ``CAN_CLOCK_DIVIDE``, ``PROP_SEG``, ``PHASE_SEG1`` and  ``PHASE_SEG2``. These are all specific to the CAN Bus that the device will connect to. 
Declare the ``can_ports`` structure used by the ``can_server`` in the main application code. This will look something like::

	can_ports p = {
		XS1_PORT_1A, 
		XS1_PORT_1B, 
		XS1_CLKBLK_1 
	}; 

Note that the CAN rx and tx must use one bit ports due to the usage of buffering in the implementation.
Next create a ``main`` function with a par of both the ``can_server`` function and an application function, these will require a channel to connect them. For example::

	int main() {
	  chan c_rx_tx;
	  par {
	    can_server(p, c_rx_tx);
	    application(c_rx_tx);
	  }
	  return 0;
	}

Now the ``application`` function is able to use the CAN Bus server.

Clock Divider
-------------
In order to set the baud rate of the device to match the CAN bus it will connect to the user has to set the define CAN_CLOCK_DIVIDER. Below is a table of the clock divider against the baud rate::

+------------------+----------------------+
| Clock Divider    | Baud Rate            |
+==================+======================+
| 1                | 1Mbps                |
+------------------+----------------------+
| 2                | 500 Kbps             |
+------------------+----------------------+
| 4                | 250 Kbps             |
+------------------+----------------------+  
| 8                | 125 Kbps             |
+------------------+----------------------+ 

In general the baud rate is::

  1/CAN_CLOCK_DIVIDER Mbps

where only integer values can be defined.

Software Requirements
---------------------

The component is built on xTIMEcomposer Tools version 12.0.
The component can be used in version 12.0 or any higher version of xTIMEcomposer Tools.
