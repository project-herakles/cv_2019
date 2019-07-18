CXXFLAGS += -std=c++11
ifneq ($(shell which nvcc 2>/dev/null),)
    CXXFLAGS += -DCUDA
endif
ifeq ($(OPTIMIZE), 1)
    CFLAGS += -O2
    CXXFLAGS += -O2
else
    CFLAGS += -g -Og
    CXXFLAGS += -g -Og
endif

.PHONY: clean all

all: trial calibration picker

picker: picker.cpp
	$(CXX) $(CXXFLAGS) picker.cpp -o picker `pkg-config --cflags --libs opencv4`

trial: ng.o crc.o protocol.o main.o
	$(CXX) ng.o crc.o protocol.o main.o -o trial `pkg-config --libs opencv4` -pthread

calibration: calibration.cpp
	$(CXX) $(CXXFLAGS) calibration.cpp -o calibration `pkg-config --cflags --libs opencv4`

ng.o: ng.cpp
	$(CXX) $(CXXFLAGS) -c ng.cpp `pkg-config --cflags opencv4`

main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp `pkg-config --cflags opencv4`

protocol.o: protocol.cpp
	$(CXX) $(CXXFLAGS) -c protocol.cpp

crc.o: crc.c
	$(CC) $(CFLAGS) -c crc.c

main.cpp: ng.h protocol.h

ng.cpp: ng.h

protocol.cpp: protocol.h

clean:
	rm -rf calibration trial picker *.o *.dSYM
