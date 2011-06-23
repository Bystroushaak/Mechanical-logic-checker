cmake_minimum_required(VERSION 2.8.1)

# Using dmd
set(CMAKE_D_COMPILER dmd)

# Using Phobos
set(CMAKE_D_USE_PHOBOS True)

set(PRJ_NAME mlchk)
PROJECT (${PRJ_NAME} D)

# Everything from parts
file (GLOB PARTS parts/*.d)
add_executable(${PRJ_NAME} main.d ${PARTS})