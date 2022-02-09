# - Find GLM
# Find the GLM header-only library
#
#  GLM::GLM - Interface target created if GLM was found.
#
#  GLM_FOUND - True if GLM was found.
#
# Original Author:
# 2019, 2021 Ryan Pavlik <ryan.pavlik@collabora.com> <ryan.pavlik@gmail.com>
#
# Copyright 2019, 2021, Collabora, Ltd.
#
# SPDX-License-Identifier: BSL-1.0

set(GLM_ROOT_DIR
    "${GLM_ROOT_DIR}"
    CACHE PATH "Directory to search for GLM")

option(GLM_ATTEMPT_CMAKE_MODULE
       "Should we attempt to use GLM's own CMake module for configuration?" ON)
mark_as_advanced(GLM_ATTEMPT_CMAKE_MODULE)

if(GLM_ATTEMPT_CMAKE_MODULE AND NOT glm_FOUND)
    # Look for a CMake config file
    find_package(glm QUIET NO_MODULE)
endif()

# Ask pkg-config for hints
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    set(_old_prefix_path "${CMAKE_PREFIX_PATH}")
    # So pkg-config uses GLM_ROOT_DIR too.
    if(GLM_ROOT_DIR)
        list(APPEND CMAKE_PREFIX_PATH ${GLM_ROOT_DIR})
    endif()
    if(GLM_FIND_VERSION)
        set(_GLM_FIND_VERSION_EXT ">=${GLM_FIND_VERSION}")
    else()
        unset(_GLM_FIND_VERSION_EXT)
    endif()
    pkg_check_modules(PC_GLM QUIET glm${_GLM_FIND_VERSION_EXT})
    # Restore
    set(CMAKE_PREFIX_PATH "${_old_prefix_path}")

    # Use pkg-config's version if we have it.
    if(PC_GLM_FOUND
       AND PC_GLM_VERSION
       AND GLM_FIND_VERSION
       AND NOT GLM_VERSION)
        set(GLM_VERSION ${PC_GLM_VERSION})
    endif()
endif()

find_path(
    GLM_INCLUDE_DIR
    NAMES glm/glm.hpp
    PATHS "${GLM_ROOT_DIR}"
    PATH_SUFFIXES include
    HINTS ${PC_GLM_INCLUDE_DIRS} ${GLM_INCLUDE_DIRS})

if(GLM_INCLUDE_DIR AND NOT GLM_VERSION)
    # Parse the header to get the version, if we can
    file(STRINGS "${GLM_INCLUDE_DIR}/glm/detail/setup.hpp" _glm_header_contents
         REGEX "GLM_VERSION_(MAJOR|MINOR|PATCH|REVISION)")
    foreach(_line IN LISTS _glm_header_contents)
        if("${_line}" MATCHES
           "GLM_VERSION_(MAJOR|MINOR|PATCH|REVISION)[^0-9]+([0-9]+)")
            set(VERSION_COMPONENT "${CMAKE_MATCH_1}")
            set(GLM_VERSION_${VERSION_COMPONENT} "${CMAKE_MATCH_2}")
        endif()
    endforeach()

    if(DEFINED GLM_VERSION_MAJOR)
        set(GLM_VERSION "${GLM_VERSION_MAJOR}")
        if(DEFINED GLM_VERSION_MINOR)
            string(APPEND GLM_VERSION . ${GLM_VERSION_MINOR})
            if(DEFINED GLM_VERSION_PATCH)
                string(APPEND GLM_VERSION . ${GLM_VERSION_PATCH})

                if(DEFINED GLM_VERSION_REVISION)
                    string(APPEND GLM_VERSION . ${GLM_VERSION_REVISION})
                endif()
            endif()
        endif()
    endif()
endif()

if(GLM_VERSION)
    set(_version_arg VERSION_VAR GLM_VERSION)
else()
    unset(_version_arg)
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(GLM REQUIRED_VARS GLM_INCLUDE_DIR
                                                    ${_version_arg})

if(GLM_FOUND AND NOT TARGET GLM::GLM)
    if(TARGET glm::glm)
        add_library(GLM::GLM ALIAS glm::glm)
    else()
        add_library(GLM::GLM INTERFACE)
        set_target_properties(GLM::GLM PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                                  "${GLM_INCLUDE_DIR}")
    endif()
endif()

if(GLM_FOUND)
    mark_as_advanced(GLM_ROOT_DIR)
endif()
mark_as_advanced(GLM_INCLUDE_DIR)

include(FeatureSummary)
set_package_properties(
    GLM PROPERTIES
    URL "https://github.com/g-truc/glm"
    DESCRIPTION
        "A header-only C++ mathematics library for graphics software based on the OpenGL Shading Language (GLSL) specifications."
)
