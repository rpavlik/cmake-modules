# Copyright 2019-2022, Collabora, Ltd.
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Original Author:
# 2019, 2021, 2022 Ryan Pavlik <ryan.pavlik@collabora.com>

#[[.rst:
FindLibevent
---------------

Find the libevent library.

Components
^^^^^^^^^^

The following components are supported:

* ``core`` - core functionality
* ``extra`` - extra functions (http, dns, rpc)
* ``pthreads`` - multithreading (not avail on windows)
* ``openssl` - OpenSSL support

If none are specified, the default is ``core``.

Targets
^^^^^^^

If successful, the following imported targets are created, based on selected/found components

* ``Libevent::core``
* ``Libevent::extra``
* ``Libevent::pthreads``
* ``Libevent::openssl``

Cache variables
^^^^^^^^^^^^^^^

The following cache variable may also be set to assist/control the operation of this module:

``Libevent_ROOT_DIR``
 The root to search for libevent.

#]]

set(Libevent_ROOT_DIR
    "${Libevent_ROOT_DIR}"
    CACHE PATH "Root to search for libevent")

if(NOT Libevent_FIND_COMPONENTS)
    set(Libevent_FIND_COMPONENTS core)
endif()
# Todo: handle in-tree/fetch-content builds?

if(NOT LIBEVENT_FOUND)
    # Look for a CMake config file
    find_package(Libevent QUIET NO_MODULE)
endif()

set(_known_components core extra openssl)
if(NOT WIN32)
    list(APPEND _known_components pthreads)
endif()

set(_got_targets FALSE)
foreach(_component ${_known_components})
    if(TARGET libevent::${_component})
        set(Libevent_${_component}_FOUND TRUE)
        set(Libevent_${_component}_LIBRARY libevent::${_component})
        set(_got_targets TRUE)
    endif()
endforeach()

if(NOT ANDROID)
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        set(_old_prefix_path "${CMAKE_PREFIX_PATH}")
        # So pkg-config uses Libevent_ROOT_DIR too.
        if(Libevent_ROOT_DIR)
            list(APPEND CMAKE_PREFIX_PATH ${Libevent_ROOT_DIR})
        endif()
        foreach(_component ${_known_components})
            pkg_check_modules(PC_Libevent_${_component} QUIET
                              libevent_${_component})
        endforeach()
        # Restore
        set(CMAKE_PREFIX_PATH "${_old_prefix_path}")
    endif()
endif()

find_path(
    Libevent_INCLUDE_DIR
    NAMES event2/event.h
    PATHS ${Libevent_ROOT_DIR}
    HINTS ${PC_Libevent_INCLUDE_DIRS} ${LIBEVENT_INCLUDE_DIRS}
    PATH_SUFFIXES include)
foreach(_component ${_known_components})
    find_library(
        Libevent_${_component}_LIBRARY
        NAMES event_${_component}
        PATHS ${Libevent_ROOT_DIR}
        HINTS ${PC_Libevent_${_component}_LIBRARY_DIRS}
        PATH_SUFFIXES lib)
    if(Libevent_${_component}_LIBRARY)
        set(Libevent_${_component}_FOUND TRUE)
    endif()
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    Libevent
    REQUIRED_VARS Libevent_INCLUDE_DIR
    HANDLE_COMPONENTS)
if(Libevent_FOUND)
    foreach(_component ${_known_components})
        mark_as_advanced(Libevent_${_component}_LIBRARY)
        if(Libevent_${_component}_FOUND AND NOT TARGET Libevent::${_component})
            if(TARGET ${Libevent_${_component}_LIBRARY})
                # we want an alias
                add_library(Libevent::${_component} ALIAS
                            ${Libevent_${_component}_LIBRARY})
            else()
                # we want an imported target
                add_library(Libevent::${_component} UNKNOWN IMPORTED)

                set_target_properties(
                    Libevent::${_component}
                    PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                               "${Libevent_INCLUDE_DIR}"
                               IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                               IMPORTED_LOCATION
                               ${Libevent_${_component}_LIBRARY})
            endif()
        endif()
    endforeach()
    mark_as_advanced(Libevent_INCLUDE_DIR)
endif()
mark_as_advanced(Libevent_ROOT_DIR Libevent_LIBRT Libevent_LIBM)

include(FeatureSummary)
set_package_properties(
    Libevent PROPERTIES
    URL "https://libevent.org/"
    DESCRIPTION "An event-notification library.")
