#.rst:
# .. command:: generate_compatibility_version_file
#
#  Create a version file for a project::
#
#    generate_compatibility_version_file(<filename>
#      [VERSION <major.minor.patch>]
#      COMPATIBILITY <AnyNewerVersion|SameMajorVersion|ExactVersion>
#      [C_ABI]
#      [CXX_LAYOUT]
#      [CXX_ABI])

#=============================================================================
# Copyright 2015 Sensics, Inc. <rylie@ryliepavlik.com>
# Copyright 2012 Alexander Neundorf <neundorf@kde.org>
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


include(CMakeParseArguments)
include(CMakePackageConfigHelpers)

set(GCVF_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "" FORCE)

function(generate_compatibility_version_file _filename)

    set(options C_ABI CXX_LAYOUT CXX_ABI)
    set(oneValueArgs VERSION COMPATIBILITY )
    set(multiValueArgs )
    cmake_parse_arguments(GCVF "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

    if(GCVF_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to generate_compatibility_version_file(): ${GCVF_UNPARSED_ARGUMENTS}")
    endif()
    set(versionTemplateFile "${CMAKE_ROOT}/Modules/BasicConfigVersion-${GCVF_COMPATIBILITY}.cmake.in")
    if(NOT EXISTS "${versionTemplateFile}")
        message(FATAL_ERROR "Bad COMPATIBILITY value used for generate_compatibility_version_file(): \"${GCVF_COMPATIBILITY}\"")
    endif()

    if(GCVF_CXX_ABI)
        set(GCVF_CXX_LAYOUT TRUE)
    endif()
    if(GCVF_CXX_LAYOUT)
        set(GCVF_C_ABI TRUE)
    endif()

    if("${GCVF_VERSION}" STREQUAL "")
        if("${PROJECT_VERSION}" STREQUAL "")
            message(FATAL_ERROR "No VERSION specified for generate_compatibility_version_file()")
        else()
            set(GCVF_VERSION ${PROJECT_VERSION})
        endif()
    endif()

    set(GCVF_WIN_CXXLAYOUT)
    if(MSVC)
        set(GCVF_WIN_CXXLAYOUT "MSVC")
    elseif(MINGW)
        set(GCVF_WIN_CXXLAYOUT "MinGW")
    elseif(WIN32)
        set(GCVF_WIN_CXXLAYOUT "other")
    endif()

    set(PREV_FILE "${_filename}.cmakeversion")
    write_basic_package_version_file("${PREV_FILE}" VERSION ${GCVF_VERSION} COMPATIBILITY ${GCVF_COMPATIBILITY})
    set(GCVF_BASIC TRUE)
    foreach(level BASIC C_ABI CXX_LAYOUT CXX_ABI)
        if(GCVF_${level})
            file(READ "${PREV_FILE}" GCVF_PREVIOUS_FILE)
            set(PREV_FILE "${_filename}.${level}")
            configure_file("${GCVF_DIR}/CompatibilityVersionFile-${level}.cmake.in" "${PREV_FILE}" @ONLY)
        endif()
    endforeach()
    configure_file("${PREV_FILE}" "${_filename}" COPYONLY)
endfunction()
