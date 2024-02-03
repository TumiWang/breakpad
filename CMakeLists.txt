cmake_minimum_required(VERSION 3.19)

project(breakpad)

set(BREAKPAD_MAIN_PROJECT OFF)
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  set(BREAKPAD_MAIN_PROJECT ON)
endif()

option(BREAKPAD_INSTALL_STATIS_LIBRARY "Install static library" ${BREAKPAD_MAIN_PROJECT})

if (WIN32)
    if (MSVC)
        set(
            BREAKPAD_HANDLER_SOURCE
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/client_info.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/client_info.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/crash_generation_client.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/crash_generation_client.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/crash_generation_server.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/crash_generation_server.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/minidump_generator.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/crash_generation/minidump_generator.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/handler/exception_handler.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/handler/exception_handler.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/common/windows/guid_string.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/common/windows/guid_string.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/common/windows/string_utils-inl.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/google_breakpad/common/minidump_format.h
        )
        add_library(breakpad_handler STATIC ${BREAKPAD_HANDLER_SOURCE})
        target_include_directories(
            breakpad_handler
            PUBLIC
            ${CMAKE_CURRENT_SOURCE_DIR}/src
        )
        target_compile_definitions(
            breakpad_handler
            PRIVATE
            UNICODE
            BREAKPAD_NO_TERMINATE_THREAD
        )

        set(
            BREAKPAD_SENDER_SOURCE
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/sender/crash_report_sender.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/client/windows/sender/crash_report_sender.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/common/windows/http_upload.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/src/common/windows/http_upload.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/common/windows/string_utils-inl.h
        )
        add_library(breakpad_sender ${BREAKPAD_SENDER_SOURCE})
        target_include_directories(
            breakpad_sender
            PUBLIC
            ${CMAKE_CURRENT_SOURCE_DIR}/src
        )
        target_compile_definitions(
            breakpad_sender
            PRIVATE
            UNICODE
        )

        if (BREAKPAD_INSTALL_STATIS_LIBRARY)
            install(TARGETS breakpad_handler breakpad_sender DESTINATION bin)
        endif()
    else()
        message(FATAL_ERROR "please use ms vc in windows")
    endif()
endif()
