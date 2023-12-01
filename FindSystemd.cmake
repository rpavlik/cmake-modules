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
# see below.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# 
# * Neither the names of Kitware, Inc., the Insight Software Consortium,
#   nor the names of their contributors may be used to endorse or promote
#   products derived from this software without specific prior written
#   permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

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
