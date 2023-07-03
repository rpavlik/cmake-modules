# Copyright 2019-2021, Collabora, Ltd.
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Original Author:
# 2021 Moses Turner <moses@collabora.com>

#.rst:
# FindLeapV2
# ---------------
#
# Find the Ultraleap v2 drivers
#
# Targets
# ^^^^^^^
#
# If successful, the following import target is created.
#
# ``LeapV2::LeapV2``
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variable may also be set to assist/control the operation of this module:
#
# ``LeapV2_ROOT_DIR``
#  The root to search for Leap v2.
#

set(LeapV2_ROOT_DIR
    "${LeapV2_ROOT_DIR}"
    CACHE PATH "Root to search for LeapV2")

find_path(
    LeapV2_INCLUDE_DIR
    NAMES Leap.h LeapMath.h
    PATHS ${LeapV2_ROOT_DIR}
    PATH_SUFFIXES include)
find_library(
    LeapV2_LIBRARY
    NAMES Leap
    PATHS ${LeapV2_ROOT_DIR}
    PATH_SUFFIXES lib lib/x64)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LeapV2 REQUIRED_VARS LeapV2_INCLUDE_DIR
                                                       LeapV2_LIBRARY)
if(LeapV2_FOUND)
    set(LeapV2_INCLUDE_DIRS "${LeapV2_INCLUDE_DIR}")
    set(LeapV2_LIBRARIES "${LeapV2_LIBRARY}")
    if(NOT TARGET LeapV2::LeapV2)
        add_library(LeapV2::LeapV2 UNKNOWN IMPORTED)
    endif()
    set_target_properties(
        LeapV2::LeapV2 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${LeapV2_INCLUDE_DIR}")
    set_target_properties(LeapV2::LeapV2 PROPERTIES IMPORTED_LOCATION
                                                    "${LeapV2_LIBRARY}")
    mark_as_advanced(LeapV2_INCLUDE_DIR LeapV2_LIBRARY)
endif()
mark_as_advanced(LeapV2_ROOT_DIR)
