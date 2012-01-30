BUILD_SUBDIRS = app_xc1_firmware app_can_phy_example
TEST_SUBDIRS = app_test

%.all:
	cd $* && xmake all

%.clean:
	cd $* && xmake clean

%.test:
	cd $* && xmake test

all: $(foreach x, $(BUILD_SUBDIRS), $x.all)
clean: $(foreach x, $(BUILD_SUBDIRS) $(TEST_SUBDIRS), $x.clean)
test: $(foreach x, $(TEST_SUBDIRS), $x.test)
