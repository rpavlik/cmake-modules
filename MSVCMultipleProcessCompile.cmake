# - Compile with multiple processes on MSVC
#
#  include(MSVCMultipleProcessCompile)
#
# Requires these CMake modules:
#  ListCombinations.cmake
#
# Original Author:
# 2009-2010 Rylie Pavlik <rylie@ryliepavlik.com>
# https://ryliepavlik.com/
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright 2009-2010, Iowa State University
#
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# SPDX-License-Identifier: BSL-1.0

if(MSVC AND NOT "${MSVC_VERSION}" LESS 1400)
	# Only available in VS 2005 and newer
	string(TOUPPER "${CMAKE_CONFIGURATION_TYPES}" _conftypesUC)
	include(ListCombinations)
	list_combinations(_varnames
		PREFIXES
		CMAKE_C_FLAGS_
		CMAKE_CXX_FLAGS_
		SUFFIXES
		${_conftypesUC})
	foreach(_var ${_varnames})
		set(${_var} "${${_var}} /MP")
	endforeach()
endif()
