cmake_minimum_required (VERSION 2.8.12) 
project (gl)

find_package(OpenGL)
if (OPENGL_FOUND)
  MESSAGE("OpenGL Correctly Found")
  include_directories(${OPENGL_INCLUDE_DIR})
else (OPENGL_FOUND)
  MESSAGE("OpenGL environment missing")
endif()

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/include
)

add_executable(
  opengl-game-of-life
  src/main.cpp
  src/vertexbuffer.cpp
  src/framebuffer.cpp
  src/shader.cpp
  src/texture.cpp
)

target_link_libraries (opengl-game-of-life glew32 glfw3 ${GLFW_LIBRARIES} ${OPENGL_LIBRARIES})