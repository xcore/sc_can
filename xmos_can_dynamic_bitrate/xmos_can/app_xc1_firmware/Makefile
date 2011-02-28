TARGET ?= XC-1
BASE_DIR = .

DEMO_SOURCE_DIRS = src

SOURCE_DIRS += $(DEMO_SOURCE_DIRS)

INCLUDE_DIRS += $(DEMO_SOURCE_DIRS) 

XCC_FLAGS += -Xmapper --map -Xmapper map.out -O3 -save-temps -g -report

EXCLUDE_FILES = 

USED_MODULES = module_can

-include ../module_xmos_common/build/Makefile.common
-include ../../xmos_common/module_xmos_common/build/Makefile.common

all: $(BIN_DIR)/xc1_firmware.xe
	@echo Build complete

clean: clean_common
