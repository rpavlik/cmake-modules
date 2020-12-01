# Copyright 2019 Collabora, Ltd.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
# SPDX-License-Identifier: BSL-1.0
#
# Original Author:
# 2019 Ryan Pavlik <ryan.pavlik@collabora.com>

#.rst:
# FindCXXGSL
# ---------------
#
# Find the C++ "Guideline Support Library".
#
# See https://github.com/Microsoft/GSL
#
# The Debian package for this is called ``libmsgsl-dev``
#
# Targets
# ^^^^^^^
#
# If successful, the following imported interface target is created.
#
# ``cxxgsl::gsl``
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set to assist/control the operation of this module:
#
# ``CXXGSL_ROOT_DIR``
#  The root to search for GSL.
#
# The following cache variables are set if a GSL target is not already found:
#
# ``CXXGSL_INCLUDE_DIR``
#  The directory to add to your include path to be able to #include <gsl/gsl>

# Set up cache variables
set(CXXGSL_ROOT_DIR
    "${CXXGSL_ROOT_DIR}"
    CACHE PATH "The root to search for GSL")

if(TARGET GSL)
    set(CXXGSL_TARGET GSL)
    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(CXXGSL REQUIRED_VARS CXXGSL_TARGET)
    if(NOT TARGET cxxgsl::gsl)
        add_library(cxxgsl::gsl ALIAS GSL)
    endif()
else()
    find_path(
        CXXGSL_INCLUDE_DIR
        NAMES gsl/gsl
        PATHS ${CXXGSL_ROOT_DIR}
        PATH_SUFFIXES include)

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(CXXGSL REQUIRED_VARS CXXGSL_INCLUDE_DIR)

    ###
    # If found, set variables and create target
    ###
    if(CXXGSL_FOUND)
        set(CXXGSL_INCLUDE_DIRS ${CXXGSL_INCLUDE_DIR})

        if(NOT TARGET cxxgsl::gsl)
            add_library(cxxgsl::gsl INTERFACE IMPORTED)
        endif()
        set_target_properties(
            cxxgsl::gsl
            PROPERTIES INTERFACE_SYSTEM_INCLUDE_DIRECTORIES
                       "${CXXGSL_INCLUDE_DIR}" INTERFACE_COMPILE_FEATURES
                       cxx_std_14)
    endif()
endif()
