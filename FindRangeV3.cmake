# - Find Range-v3
# Find the range-v3 header-only library
#
#  RangeV3::RangeV3 - Imported target to use
#  RANGEV3_FOUND - True if range-v3 was found.
#
# Original Author:
# 2018 Ryan Pavlik <ryan.pavlik@gmail.com> <abiryan@ryand.net>
#
# Copyright 2018, Collabora, Ltd.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# SPDX-License-Identifier: BSL-1.0


set(RANGEV3_ROOT_DIR
    "${RANGEV3_ROOT_DIR}"
	CACHE
	PATH
    "Directory to search for range-v3")
find_path(RANGEV3_INCLUDE_DIR
    NAMES
    range/v3/all.hpp
    PATHS
    "${RANGEV3_ROOT_DIR}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RangeV3
    DEFAULT_MSG
    RANGEV3_INCLUDE_DIR)

if(RANGEV3_FOUND)
    if(NOT TARGET RangeV3::RangeV3)
        add_library(RangeV3::RangeV3 INTERFACE IMPORTED)
        set_target_properties(RangeV3::RangeV3
            PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${RANGEV3_INCLUDE_DIR}")
    endif()
    set(RANGEV3_INCLUDE_DIRS ${RANGEV3_INCLUDE_DIR})
    mark_as_advanced(RANGEV3_ROOT_DIR)
endif()

mark_as_advanced(RANGEV3_INCLUDE_DIR)
