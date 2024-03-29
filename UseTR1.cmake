# - Use settings to enable access to C++ TR1
#
# This calls include_directories and link_directories as needed to
# permit TR1 support.
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

if(__use_tr1)
	return()
endif()
set(__use_tr1 YES)


if(TR1_INCLUDE_DIRS)
	include_directories(${TR1_INCLUDE_DIRS})
endif()

if(TR1_LIBRARY_DIRS)
	link_directories(${TR1_LIBRARY_DIRS})
endif()
