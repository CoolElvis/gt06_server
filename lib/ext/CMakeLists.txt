cmake_minimum_required(VERSION 3.5)
project(sandbox)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib")

set(SOURCE_FILES crc_16.cpp)
add_executable(sandbox main.cpp)

set(SOURCE_LIB crc_16.cpp)

add_library(crc_16 SHARED ${SOURCE_LIB})
