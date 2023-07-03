# Copyright 2021-2022, Collabora, Ltd.
#
# SPDX-License-Identifier: BSL-1.0
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Original Author:
# 2021 Moses Turner <moses@collabora.com>
# 2021 Ryan Pavlik <ryan.pavlik@collabora.com>

#.rst:
# FindONNXRuntime
# ---------------
#
# Find the ONNX runtime
#
# Targets
# ^^^^^^^
#
# If successful, the following import target is created.
#
# ``ONNXRuntime::ONNXRuntime``
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variable may also be set to assist/control the operation of this module:
#
# ``ONNXRuntime_ROOT_DIR``
#  The root to search for ONNX runtime.
#

include(FeatureSummary)
set_package_properties(
    ONNXRuntime PROPERTIES
    URL "https://onnxruntime.ai/"
    DESCRIPTION "Machine learning runtime")

set(ONNXRuntime_ROOT_DIR
    "${ONNXRuntime_ROOT_DIR}"
    CACHE PATH "Root to search for ONNXRuntime")

find_package(PkgConfig)
pkg_check_modules(PC_ONNXRuntime QUIET libonnxruntime)

find_library(
    ONNXRuntime_LIBRARY
    NAMES onnxruntime
    PATHS ${ONNXRuntime_ROOT_DIR}
    PATH_SUFFIXES lib
    HINTS ${PC_ONNXRuntime_LIBRARY_DIRS})
find_path(
    ONNXRuntime_INCLUDE_DIR onnxruntime_cxx_api.h
    PATHS ${ONNXRuntime_ROOT_DIR}
    PATH_SUFFIXES onnxruntime include include/onnxruntime onnxruntime/core/session
                  include/onnxruntime/core/session
    HINTS ${PC_ONNXRuntime_INCLUDE_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    ONNXRuntime REQUIRED_VARS ONNXRuntime_INCLUDE_DIR ONNXRuntime_LIBRARY)

if(ONNXRuntime_FOUND)
    set(ONNXRuntime_INCLUDE_DIRS ${ONNXRuntime_INCLUDE_DIR})
    set(ONNXRuntime_LIBRARIES "${ONNXRuntime_LIBRARY}")
    if(NOT TARGET ONNXRuntime::ONNXRuntime)
        add_library(ONNXRuntime::ONNXRuntime UNKNOWN IMPORTED)
    endif()
    set_target_properties(
        ONNXRuntime::ONNXRuntime PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                            "${ONNXRuntime_INCLUDE_DIRS}")
    set_target_properties(
        ONNXRuntime::ONNXRuntime
        PROPERTIES IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                   IMPORTED_LOCATION "${ONNXRuntime_LIBRARY}")
    mark_as_advanced(ONNXRuntime_INCLUDE_DIRS ONNXRuntime_LIBRARY)
endif()

mark_as_advanced(ONNXRuntime_ROOT_DIR)
