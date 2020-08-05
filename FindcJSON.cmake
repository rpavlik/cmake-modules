# Copyright 2019-2020, Collabora, Ltd.
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Original Author:
# 2019-2020 Ryan Pavlik <ryan.pavlik@collabora.com>

#.rst:
# FindcJSON
# ---------------
#
# Find the cJSON lightweight JSON parser
#
# Targets
# ^^^^^^^
#
# If successful, the following import target is created.
#
# ``cJSON::cJSON``
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variable may also be set to assist/control the operation of this module:
#
# ``CJSON_ROOT_DIR``
#  The root to search for cJSON.

set(CJSON_ROOT_DIR
    "${CJSON_ROOT_DIR}"
    CACHE PATH "Root to search for cJSON")

find_path(
    CJSON_INCLUDE_DIR
    NAMES cjson/cJSON.h
    PATHS ${CJSON_ROOT_DIR}
    PATH_SUFFIXES include)
find_library(
    CJSON_LIBRARY
    NAMES cjson
    PATHS ${CJSON_ROOT_DIR}
    PATH_SUFFIXES lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(cJSON REQUIRED_VARS CJSON_INCLUDE_DIR
                                                      CJSON_LIBRARY)
if(CJSON_FOUND)
    set(CJSON_INCLUDE_DIRS "${CJSON_INCLUDE_DIR}")
    set(CJSON_LIBRARIES "${CJSON_LIBRARY}")
    if(NOT TARGET cJSON::cJSON)
        add_library(cJSON::cJSON UNKNOWN IMPORTED)
    endif()
    set_target_properties(cJSON::cJSON PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                                  "${CJSON_INCLUDE_DIR}")
    set_target_properties(
        cJSON::cJSON PROPERTIES IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                IMPORTED_LOCATION "${CJSON_LIBRARY}")
    mark_as_advanced(CJSON_INCLUDE_DIR CJSON_LIBRARY)
endif()
mark_as_advanced(CJSON_ROOT_DIR)
