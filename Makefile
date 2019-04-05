#################################################
# Makefile to run unit tests and create a driver
# for a lidar data processing program
#
# Author: Ravi Shankar (rvishnkr)
# Date  : 04 Dec 2018
#################################################

# Usage
#######
# make geotiff-driver - creates the main executable in bin/
# make pls-info       - creates a .pls file info checking tool in bin/
# make clean          - removes all files generated by make

# Points to the root of Pulse Waves, relative to where this file is.
PULSE_DIR = deps/PulseWaves

# Where to find user code, relative to where this file is.
SRC = src

# Different directories, relative to where this file is.
BIN = bin
OBJ = obj
LIB = lib

# Flags passed to the C and C++ compiler
########################################
# -g:       Produce debugging information in the operating system’s 
#           native format
#
# -Wall:    Enables all warning flags 
#  	    (https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html)
#
# -Wextra:  This enables extra warning flags that are not enabled by -Wall
#
# -pthread: Link with the POSIX threads library
#
# -Idir:    Add the directory 'dir' to the list of directories to be searched 
#           for heade# files during preprocessing

# -llib:    Search the library named 'lib' when linking
CXXFLAGS += -g -Wall -Wextra -pthread -I$(PULSE_DIR)/inc
CFLAGS += -g -Wall -Wextra -pthread -I$(PULSE_DIR)/inc


# Builds specific object files
$(OBJ)/FlightLineData.o: $(SRC)/FlightLineData.cpp
	$(CXX) -c -o $@ $^ $(CFLAGS) -L$(PULSE_DIR)/lib

$(OBJ)//WaveGPSInformation.o: $(SRC)/WaveGPSInformation.cpp
	$(CXX) -c -o $@ $^ $(CFLAGS) -L$(PULSE_DIR)/lib

$(OBJ)/PulseData.o: $(SRC)/PulseData.cpp
	$(CXX) -c -o $@ $^ $(CFLAGS) -L$(PULSE_DIR)/lib

$(OBJ)//LidarVolume.o: $(SRC)/LidarVolume.cpp
	$(CXX) -c -o $@ $^ $(CFLAGS) -lgdal -L$(PULSE_DIR)/lib

$(OBJ)/GaussianFitter.o: $(SRC)/GaussianFitter.cpp
	$(CXX) -g -fpermissive -c -o $@ $^ -lm \
		-lgsl -lgslcblas	

# Builds all object files
$(OBJ)/%.o: $(SRC)/%.cpp
	$(CXX) -c -o $@ $^ $(CFLAGS)

# Builds the info tool 
pls-info: $(BIN)/pls-info

$(BIN)/pls-info: $(OBJ)/GetPLSDetails.o $(OBJ)/PulseData.o
	$(CXX) $(CXXFLAGS) -g -lpthread $^ -o $@ -L \
		$(PULSE_DIR)/lib -lpulsewaves

$(OBJ)/GetPLSDetails.o: $(SRC)/GetPLSDetails.cpp
	$(CXX) -c -o $@ $^ $(CFLAGS) -L$(PULSE_DIR)/lib

# Builds the pls to geotiff driver
geotiff-driver: $(BIN)/geotiff-driver

$(BIN)/geotiff-driver: $(OBJ)/PlsToGeotiff.o $(OBJ)/CmdLine.o \
			$(OBJ)/WaveGPSInformation.o $(OBJ)/PulseData.o \
			$(OBJ)/FlightLineData.o $(OBJ)/LidarVolume.o \
			$(OBJ)/Peak.o $(OBJ)/GaussianFitter.o
	$(CXX) $(CXXFLAGS) -g -lpthread $^ -o $@ -L \
		$(PULSE_DIR)/lib -lpulsewaves -lgdal -lm -lgsl \
		-lgslcblas 

$(OBJ)/PlsToGeotiff.o: $(SRC)/PlsToGeotiff.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $^



# A phony target is one that is not really the name of a file; rather it 
# is just a name for a recipe to be executed when you make an explicit request. 
# There are two reasons to use a phony target: to avoid a conflict with a file 
# of the same name, and to improve performance.
.PHONY: clean

# Clean up when done. 
# Removes all object, library and executable files
clean: 
	clear
	rm -f $(BIN)/*
	rm -f $(OBJ)/*
	rm -f $(LIB)/*
	rm -f $(SRC)/*.o
	
