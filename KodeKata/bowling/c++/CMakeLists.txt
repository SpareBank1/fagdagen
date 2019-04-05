cmake_minimum_required (VERSION 2.8)
project (CodeKataCpp)

# CMake 2.8 is ancient, and doesn't support the latest C++ standards properly (C++11, C++14 or C++17)
include(CMakeInclude.txt)
use_cxx11()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

add_executable(
  kata_tests
  tests/test.cpp
  src/bowling_game.cpp
)
