# - Utility function for Find modules considering multiple possible versions
#
# Requires these CMake modules:
#  no additional modules required
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

if(__check_version)
	return()
endif()
set(__check_version YES)

function(check_version var packagename version)
	# By default, we say that the version is good enough
	set(_result TRUE)

	# Was a version requested?  If so, what is our test condition?
	if(${packagename}_FIND_VERSION)
		if(${packagename}_FIND_VERSION_EXACT)
			# Yes, an exact == version was requested - check it.

			if(NOT "${version}" VERSION_EQUAL "${${packagename}_FIND_VERSION}")
				# version is not an exact match
				set(_result FALSE)
			endif()
		else()
			# Yes, a minimum >= version was requested - check it.

			if("${version}" VERSION_LESS "${${packagename}_FIND_VERSION}")
				# version is lower than requested
				set(_result FALSE)
			endif()

		endif()
	endif()

	# Return _result
	set(${var} ${_result} PARENT_SCOPE)
endfunction()
