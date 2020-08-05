# Copyright 2019 Collabora, Ltd.
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Original Author:
# 2019 Ryan Pavlik <ryan.pavlik@collabora.com>

#.rst:
# FindOpenHMD
# ---------------
#
# Find the OpenHMD immersive computing interface library.
#
# See http://www.openhmd.net/
#
# Targets
# ^^^^^^^
#
# If successful, the following import target is created.
#
# ``openhmd::openhmd``
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variable may also be set to assist/control the operation of this module:
#
# ``OPENHMD_ROOT_DIR``
#  The root to search for OpenHMD.

set(OPENHMD_ROOT_DIR
    "${OPENHMD_ROOT_DIR}"
    CACHE PATH "Root to search for OpenHMD")

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    set(_old_prefix_path "${CMAKE_PREFIX_PATH}")
    # So pkg-config uses OPENHMD_ROOT_DIR too.
    if(OPENHMD_ROOT_DIR)
        list(APPEND CMAKE_PREFIX_PATH ${OPENHMD_ROOT_DIR})
    endif()
    pkg_check_modules(PC_OPENHMD QUIET openhmd)
    # Restore
    set(CMAKE_PREFIX_PATH "${_old_prefix_path}")
endif()

find_path(
    OPENHMD_INCLUDE_DIR
    NAMES openhmd.h
    PATHS ${OPENHMD_ROOT_DIR}
    HINTS ${PC_OPENHMD_INCLUDE_DIRS}
    PATH_SUFFIXES include openhmd include/openhmd)
find_library(
    OPENHMD_LIBRARY
    NAMES openhmd
    PATHS ${OPENHMD_ROOT_DIR} ${OPENHMD_ROOT_DIR}/build
    HINTS ${PC_OPENHMD_LIBRARY_DIRS}
    PATH_SUFFIXES lib)
find_library(OPENHMD_LIBRT rt)
find_library(OPENHMD_LIBM m)

find_package(Threads QUIET)

set(_ohmd_extra_deps)

set(OPENHMD_HIDAPI_TYPE)
if(OPENHMD_LIBRARY AND "${OPENHMD_LIBRARY}" MATCHES
                       "${CMAKE_STATIC_LIBRARY_SUFFIX}")
    # Looks like a static library
    if(PC_OPENHMD_FOUND)
        # See if we need a particular hidapi.
        list(REMOVE_ITEM PC_OPENHMD_LIBRARIES openhmd)
        if("${PC_OPENHMD_LIBRARIES}" MATCHES hidapi-libusb)
            set(OPENHMD_HIDAPI_TYPE libusb)
            find_package(HIDAPI QUIET COMPONENTS libusb)
            list(APPEND _ohmd_extra_deps HIDAPI_libusb_FOUND)
        elseif("${PC_OPENHMD_LIBRARIES}" MATCHES hidapi-hidraw)
            set(OPENHMD_HIDAPI_TYPE hidraw)
            find_package(HIDAPI QUIET COMPONENTS hidraw)
            list(APPEND _ohmd_extra_deps HIDAPI_hidraw_FOUND)
        endif()
    endif()
    if(NOT PC_OPENHMD_FOUND OR NOT OPENHMD_HIDAPI_TYPE)
        # Undifferentiated
        set(OPENHMD_HIDAPI_TYPE undifferentiated)
        find_package(HIDAPI QUIET)
        list(APPEND _ohmd_extra_deps HIDAPI_FOUND)
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    OpenHMD REQUIRED_VARS OPENHMD_INCLUDE_DIR OPENHMD_LIBRARY THREADS_FOUND)
if(OPENHMD_FOUND)
    set(OPENHMD_INCLUDE_DIRS "${OPENHMD_INCLUDE_DIR}")
    set(OPENHMD_LIBRARIES "${OPENHMD_LIBRARY}")
    if(NOT TARGET OpenHMD::OpenHMD)
        add_library(OpenHMD::OpenHMD UNKNOWN IMPORTED)
    endif()
    set_target_properties(
        OpenHMD::OpenHMD
        PROPERTIES IMPORTED_LOCATION "${OPENHMD_LIBRARY}"
                   INTERFACE_INCLUDE_DIRECTORIES "${OPENHMD_INCLUDE_DIR}"
                   IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                   IMPORTED_LINK_INTERFACE_LIBRARIES Threads::Threads)

    if("${OPENHMD_HIDAPI_TYPE}" STREQUAL libusb)
        set_property(
            TARGET OpenHMD::OpenHMD
            APPEND
            PROPERTY IMPORTED_LINK_INTERFACE_LIBRARIES HIDAPI::hidapi-libusb)
        list(APPEND OPENHMD_LIBRARIES HIDAPI::hidapi-libusb)
    elseif("${OPENHMD_HIDAPI_TYPE}" STREQUAL hidraw)
        set_property(
            TARGET OpenHMD::OpenHMD
            APPEND
            PROPERTY IMPORTED_LINK_INTERFACE_LIBRARIES HIDAPI::hidapi-hidraw)
        list(APPEND OPENHMD_LIBRARIES HIDAPI::hidapi-hidraw)
    elseif("${OPENHMD_HIDAPI_TYPE}" STREQUAL undifferentiated)
        set_property(
            TARGET OpenHMD::OpenHMD
            APPEND
            PROPERTY IMPORTED_LINK_INTERFACE_LIBRARIES HIDAPI::hidapi)
        list(APPEND OPENHMD_LIBRARIES HIDAPI::hidapi)
    endif()
    mark_as_advanced(OPENHMD_INCLUDE_DIR OPENHMD_LIBRARY)
endif()
mark_as_advanced(OPENHMD_ROOT_DIR OPENHMD_LIBRT OPENHMD_LIBM)
