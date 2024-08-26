# Install script for directory: /home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/bin/objdump")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/ggml/src/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/ggml/src/libggml.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-alloc.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-backend.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-blas.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-cann.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-cuda.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-kompute.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-metal.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-rpc.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-sycl.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-vulkan.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/ggml/src/libggml.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libggml.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-alloc.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-backend.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-blas.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-cann.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-cuda.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-kompute.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-metal.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-rpc.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-sycl.h"
    "/home/phaedrus/Forge/GH/Qompass/Equator/C++/llama.cpp/ggml/include/ggml-vulkan.h"
    )
endif()

