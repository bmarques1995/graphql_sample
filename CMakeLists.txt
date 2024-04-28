cmake_minimum_required(VERSION 3.22)

option(BUILD_SHARED_LIBS "Treat All projects as shared libs" OFF)

project(graphql_sample)
set(CMAKE_CXX_STANDARD 20)

if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

file(GLOB_RECURSE GQL_HDRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "./src/*.hpp")
file(GLOB_RECURSE GQL_SRCS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "./src/*.cpp")

set(TARGET_NAME graphql_sample)

find_package(Drogon REQUIRED)
find_package(Boost REQUIRED COMPONENTS system date_time url)
find_package(mailio REQUIRED)

add_executable(${TARGET_NAME} ${GQL_HDRS} ${GQL_SRCS})
target_include_directories(${TARGET_NAME} PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/src" "${CMAKE_PREFIX_PATH}/include")
target_link_directories(${TARGET_NAME} PUBLIC "${CMAKE_PREFIX_PATH}/lib")
target_link_libraries(${TARGET_NAME} PUBLIC Drogon::Drogon mailio)

set_target_properties(${TARGET_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_PREFIX_PATH}/bin")
set_target_properties(${TARGET_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_PREFIX_PATH}/bin")
set_target_properties(${TARGET_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_PREFIX_PATH}/bin")
set_target_properties(${TARGET_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${CMAKE_PREFIX_PATH}/lib")
set_target_properties(${TARGET_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_PREFIX_PATH}/lib")
set_target_properties(${TARGET_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_PREFIX_PATH}/lib")
set_target_properties(${TARGET_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_PREFIX_PATH}/lib")
set_target_properties(${TARGET_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_PREFIX_PATH}/lib")
set_target_properties(${TARGET_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_PREFIX_PATH}/lib")