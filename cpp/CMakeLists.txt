cmake_minimum_required(VERSION 3.28)

project(cpp-template VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(${PROJECT_NAME}-warnings INTERFACE)
target_compile_options(${PROJECT_NAME}-warnings INTERFACE
    -Wall
    -Wextra
    -Wpedantic
)

add_library(${PROJECT_NAME}-lib
    src/lib.cpp
)
target_include_directories(${PROJECT_NAME}-lib PUBLIC src)
target_link_libraries(${PROJECT_NAME}-lib PRIVATE ${PROJECT_NAME}-warnings)

add_executable(${PROJECT_NAME} src/main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE
    ${PROJECT_NAME}-lib
    ${PROJECT_NAME}-warnings
)

include(CTest)
if(BUILD_TESTING)
    find_package(doctest REQUIRED)
    add_executable(${PROJECT_NAME}-tests
        tests/main.cpp
        tests/test_main.cpp
    )
    target_link_libraries(${PROJECT_NAME}-tests PRIVATE
        ${PROJECT_NAME}-lib
        ${PROJECT_NAME}-warnings
        doctest::doctest
    )
    include(doctest)
    doctest_discover_tests(${PROJECT_NAME}-tests)
endif()
