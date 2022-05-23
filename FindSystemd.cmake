#.rst:
# FindSystemd
# -------
#
# Find Systemd library
#
# Try to find Systemd library on UNIX systems. The following values are defined
#
# ::
#
#   SYSTEMD_FOUND         - True if Systemd is available
#   SYSTEMD_INCLUDE_DIRS  - Include directories for Systemd
#   SYSTEMD_LIBRARIES     - List of libraries for Systemd
#   SYSTEMD_DEFINITIONS   - List of definitions for Systemd
#
#=============================================================================
# Copyright (c) 2015 Jari Vetoniemi
# Copyright (c) 2020-2021 Collabora, Ltd.
#
# Distributed under the OSI-approved BSD License (the "License");
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# SPDX-License-Identifier: BSD-3-Clause

include(FeatureSummary)
set_package_properties(
    Systemd PROPERTIES
    URL "http://freedesktop.org/wiki/Software/systemd/"
    DESCRIPTION "System and Service Manager")

if(NOT ANDROID)
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        pkg_check_modules(PC_SYSTEMD QUIET libsystemd)
    endif()
endif()

find_library(
    SYSTEMD_LIBRARY
    NAMES systemd
    HINTS ${PC_SYSTEMD_LIBRARY_DIRS})
find_path(SYSTEMD_INCLUDE_DIR systemd/sd-login.h
          HINTS ${PC_SYSTEMD_INCLUDE_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Systemd DEFAULT_MSG SYSTEMD_INCLUDE_DIR
                                  SYSTEMD_LIBRARY)
if(SYSTEMD_FOUND)
    set(SYSTEMD_LIBRARIES ${SYSTEMD_LIBRARY})
    set(SYSTEMD_INCLUDE_DIRS ${SYSTEMD_INCLUDE_DIR})
    set(SYSTEMD_DEFINITIONS ${PC_SYSTEMD_CFLAGS_OTHER})
endif()
