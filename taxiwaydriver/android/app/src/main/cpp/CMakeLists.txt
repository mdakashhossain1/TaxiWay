cmake_minimum_required(VERSION 3.10.2)
project(native_secrets)

add_library(native_secrets SHARED native_secrets.cpp)

find_library(log-lib log)
target_link_libraries(native_secrets ${log-lib})
