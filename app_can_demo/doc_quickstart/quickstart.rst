.. _CAN_Bus_Demo_Quickstart:

CAN Bus Demo Quickstart Guide
=============================

sc_can demo : Quick Start Guide
-------------------------------

This simple demonstration of xTIMEcomposer Studio functionality uses the XA-SK-ISBUS Slice Card together with the xSOFTip ``module_can`` to demonstrate how the module is used to send and receive 

Hardware Setup
++++++++++++++

The XP-SKC-L2 Slicekit Core board has four slots with edge connectors: ``SQUARE``, ``CIRCLE``,``TRIANGLE`` and ``STAR``. 

To setup up the system:

   #. Connect XA-SK-ISBUS Slice Card to the XP-SKC-L2 Slicekit Core board using the connector marked with the ``STAR``.
   #. Connect the XTAG Adapter to Slicekit Core board, and connect XTAG-2 to the Adapter. 
   #. Connect the XTAG-2 to host PC. Note that the USB cable is not provided with the Slicekit starter kit.
   #. Set the ``XMOS LINK`` to ``ON`` on the XTAG Adapter.
   #. Switch on the power supply to the Slicekit Core board.

.. figure:: images/hardware_setup.jpg
   :width: 400px
   :align: center

   Hardware Setup for CAN Bus Demo
   
	
Import and Build the Application
++++++++++++++++++++++++++++++++

   #. Open xTIMEcomposer and check that it is operating in online mode. Open the edit perspective (Window->Open Perspective->XMOS Edit).
   #. Locate the ``'Slicekit CAN Bus Demo'`` item in the xSOFTip pane on the bottom left of the window and drag it into the Project Explorer window in the xTIMEcomposer. This will also cause the modules on which this application depends (in this case, ``module_can``) to be imported as well. 
   #. Click on the ``app_can_demo`` item in the Project Explorer pane then click on the build icon (hammer) in xTIMEcomposer. Check the console window to verify that the application has built successfully. There will be quite a number of warnings that ``bidirectional buffered port not supported in hardware``. These can be safely ignored for this component.

For help in using xTIMEcomposer, try the xTIMEcomposer tutorial, which you can find by selecting Help->Tutorials from the xTIMEcomposer menu.

Note that the Developer Column in the xTIMEcomposer on the right hand side of your screen provides information on the xSOFTip components you are using. Select the ``module_can`` component in the Project Explorer, and you will see its description together with API documentation. Having done this, click the `back` icon until you return to this quickstart guide within the Developer Column.

Run the Application
+++++++++++++++++++

Now that the application has been compiled, the next step is to run it on the Slicekit Core Board using the tools to load the application over JTAG (via the XTAG2 and Xtag Adapter card) into the xCORE multicore microcontroller.

   #. Select the file ``app_can_demo.xc`` in the ``app_can_demo`` project from the Project Explorer.
   #. Click on the ``Run`` icon (the white arrow in the green circle). 
   #. At the ``Select Device`` dialog select ``XMOS XTAG-2 connect to L1[0..1]`` and click ``OK``.
   #. The debug console window in xTIMEcomposer should then display the frames as it transmits and recieves them.
    
Next Steps
++++++++++

Now that the demo has been run you could try and adjust the ``BUF_WORDS`` setting. Note, if you try to allocate more than 64KB of internal XCore memory then the demo will not compile as the Xcore wont be able to hold the image.

Look at the Code
................

   #. Examine the application code. In xTIMEcomposer navigate to the ``src`` directory under app_can_demo and double click on the ``app_can_demo.xc`` file within it. The file will open in the central editor window.
   #. Find the main function and note that it runs the ``application()`` function on a single logical core. 
   #. This example uses a polling loop. After transmitting a frame it polls the server for new frames or waits for a 2 second delay to end. This functionality is achieved using a ``select`` statement.
   #. The demo uses xscope for fast printing. The user can swich to JTAG output but it will be slower.
