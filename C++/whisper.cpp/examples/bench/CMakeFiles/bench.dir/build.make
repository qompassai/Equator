# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp

# Include any dependencies generated for this target.
include examples/bench/CMakeFiles/bench.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include examples/bench/CMakeFiles/bench.dir/compiler_depend.make

# Include the progress variables for this target.
include examples/bench/CMakeFiles/bench.dir/progress.make

# Include the compile flags for this target's objects.
include examples/bench/CMakeFiles/bench.dir/flags.make

examples/bench/CMakeFiles/bench.dir/bench.cpp.o: examples/bench/CMakeFiles/bench.dir/flags.make
examples/bench/CMakeFiles/bench.dir/bench.cpp.o: examples/bench/bench.cpp
examples/bench/CMakeFiles/bench.dir/bench.cpp.o: examples/bench/CMakeFiles/bench.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object examples/bench/CMakeFiles/bench.dir/bench.cpp.o"
	cd /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench && ccache /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT examples/bench/CMakeFiles/bench.dir/bench.cpp.o -MF CMakeFiles/bench.dir/bench.cpp.o.d -o CMakeFiles/bench.dir/bench.cpp.o -c /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench/bench.cpp

examples/bench/CMakeFiles/bench.dir/bench.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/bench.dir/bench.cpp.i"
	cd /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench/bench.cpp > CMakeFiles/bench.dir/bench.cpp.i

examples/bench/CMakeFiles/bench.dir/bench.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/bench.dir/bench.cpp.s"
	cd /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench/bench.cpp -o CMakeFiles/bench.dir/bench.cpp.s

# Object files for target bench
bench_OBJECTS = \
"CMakeFiles/bench.dir/bench.cpp.o"

# External object files for target bench
bench_EXTERNAL_OBJECTS =

bin/bench: examples/bench/CMakeFiles/bench.dir/bench.cpp.o
bin/bench: examples/bench/CMakeFiles/bench.dir/build.make
bin/bench: src/libwhisper.so.1.6.2
bin/bench: ggml/src/libggml.so
bin/bench: examples/bench/CMakeFiles/bench.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../bin/bench"
	cd /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/bench.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/bench/CMakeFiles/bench.dir/build: bin/bench
.PHONY : examples/bench/CMakeFiles/bench.dir/build

examples/bench/CMakeFiles/bench.dir/clean:
	cd /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench && $(CMAKE_COMMAND) -P CMakeFiles/bench.dir/cmake_clean.cmake
.PHONY : examples/bench/CMakeFiles/bench.dir/clean

examples/bench/CMakeFiles/bench.dir/depend:
	cd /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench /home/phaedrus/Forge/GH/Qompass/Equator/C++/whisper.cpp/examples/bench/CMakeFiles/bench.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : examples/bench/CMakeFiles/bench.dir/depend
