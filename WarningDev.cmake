# - Print a developer warning, using author_warning if we have cmake 2.8
#
#  warning_dev("your desired message")
#
# Original Author:
# 2010 Rylie Pavlik <rylie@ryliepavlik.com>
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

function(warning_dev _yourmsg)
	if("1.${CMAKE_VERSION}" VERSION_LESS "1.2.8.0")
		# CMake version <2.8.0
		message(STATUS
			"The following is a developer warning - end users may ignore it")
		message(STATUS "Dev Warning: ${_yourmsg}")
	else()
		message(AUTHOR_WARNING "${_yourmsg}")
	endif()
endfunction()
