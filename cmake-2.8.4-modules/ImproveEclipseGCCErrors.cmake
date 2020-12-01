# - Add a GCC flag so that the errors are more suitable to parsing by Eclipse
#
#  include(ImproveEclipseGCCErrors)
#
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright 2009-2010, Iowa State University
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file ../LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
# SPDX-License-Identifier: BSL-1.0

if("${CMAKE_GENERATOR}" MATCHES "Eclipse" AND CMAKE_COMPILER_IS_GNUCXX)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fmessage-length=0")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmessage-length=0")
endif()
