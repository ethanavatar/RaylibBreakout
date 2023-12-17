cmake_minimum_required(VERSION 3.2)
project(platformer)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Change path from /src if needed, or add more directories
file(GLOB_RECURSE sources
    "${CMAKE_SOURCE_DIR}/src/*.c"
    "${CMAKE_SOURCE_DIR}/deps/raylib/src/*.c"
)

add_library(my_app ${sources})
target_include_directories(my_app PUBLIC "{CMAKE_SOURCE_DIR}/include")
target_include_directories(my_app PUBLIC "{CMAKE_SOURCE_DIR}/deps/raylib/build/raylib/include")
