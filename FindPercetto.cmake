# Copyright 2021-2022, Collabora, Ltd.
#
# SPDX-License-Identifier: BSL-1.0
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Original Author:
# 2021-2022 Ryan Pavlik <ryan.pavlik@collabora.com> <ryan.pavlik@gmail.com>

#[[.rst:
FindPercetto
---------------

Find the Percetto C wrapper around the Perfetto tracing API.

Targets
^^^^^^^

If successful, the following imported targets are created.

* ``percetto::percetto``

Cache variables
^^^^^^^^^^^^^^^

The following cache variable may also be set to assist/control the operation of this module:

``Percetto_ROOT_DIR``
 The root to search for Percetto.
#]]

set(Percetto_ROOT_DIR
    "${Percetto_ROOT_DIR}"
    CACHE PATH "Root to search for Percetto")

include(FeatureSummary)
set_package_properties(
    Percetto PROPERTIES
    URL "https://github.com/olvaffe/percetto/"
    DESCRIPTION "A C wrapper around the C++ Perfetto tracing SDK.")

include(FindPackageHandleStandardArgs)

# See if it's being built in a current project.
if(NOT Percetto_FOUND)
    if(TARGET percetto::percetto)
        # OK, good - this is what we wanted
    elseif(TARGET Percetto::percetto)
        # we now prefer lowercase
        add_library(percetto::percetto INTERFACE IMPORTED)
        set_target_properties(
            percetto::percetto PROPERTIES INTERFACE_LINK_LIBRARIES
                                          Percetto::percetto)
    endif()

    if(TARGET percetto::percetto)
        set(Percetto_LIBRARY percetto::percetto)
        find_package_handle_standard_args(Percetto
                                          REQUIRED_VARS Percetto_LIBRARY)
        return()
    endif()
endif()

# See if we can find something made by android prefab (gradle), or exported by CMake
find_package(Percetto QUIET CONFIG NAMES percetto Percetto)
if(Percetto_FOUND)
    find_package_handle_standard_args(Percetto CONFIG_MODE)
    if(TARGET percetto::percetto)
        # OK, good - this is what we wanted
    elseif(TARGET Percetto::percetto)
        # we now prefer lowercase
        add_library(percetto::percetto INTERFACE IMPORTED)
        set_target_properties(
            percetto::percetto PROPERTIES INTERFACE_LINK_LIBRARIES
                                          Percetto::percetto)
    else()
        message(FATAL_ERROR "assumptions failed")
    endif()
    return()
endif()

if(NOT ANDROID)
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        set(_old_prefix_path "${CMAKE_PREFIX_PATH}")
        # So pkg-config uses Percetto_ROOT_DIR too.
        if(Percetto_ROOT_DIR)
            list(APPEND CMAKE_PREFIX_PATH ${Percetto_ROOT_DIR})
        endif()
        pkg_check_modules(PC_percetto QUIET percetto)
        # Restore
        set(CMAKE_PREFIX_PATH "${_old_prefix_path}")
    endif()
endif()

find_path(
    Percetto_INCLUDE_DIR
    NAMES percetto.h
    PATHS ${Percetto_ROOT_DIR}
    HINTS ${PC_percetto_INCLUDE_DIRS}
    PATH_SUFFIXES include)

find_library(
    Percetto_LIBRARY
    NAMES percetto
    PATHS ${Percetto_ROOT_DIR}
    HINTS ${PC_percetto_LIBRARY_DIRS}
    PATH_SUFFIXES lib)

find_package_handle_standard_args(Percetto REQUIRED_VARS Percetto_INCLUDE_DIR
                                                         Percetto_LIBRARY)
if(Percetto_FOUND)
    if(NOT TARGET percetto::percetto)
        add_library(percetto::percetto UNKNOWN IMPORTED)

        set_target_properties(
            percetto::percetto
            PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${Percetto_INCLUDE_DIR}"
                       IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                       IMPORTED_LOCATION ${Percetto_LIBRARY})
    endif()
    mark_as_advanced(Percetto_LIBRARY Percetto_INCLUDE_DIR)
endif()
mark_as_advanced(Percetto_ROOT_DIR)
