# - List filtering functions
#
#  list_filter(var regex listitems...) - where var is the name of
#   your desired output variable, regex is the regex whose matching items
#   WILL be put in the output variable, and everything else is considered
#   a list item to be filtered.
#
#  list_filter_out(var regex listitems...) - where var is the name of
#   your desired output variable, regex is the regex whose matching items
#   will NOT be put in the output variable, and everything else is considered
#   a list item to be filtered.
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

if(__list_filter_out)
	return()
endif()
set(__list_filter_out YES)

function(list_filter_out var regex)
	set(_out)
	foreach(_item ${ARGN})
		set(_re)
		string(REGEX MATCH "${regex}" _re "${_item}")
		if(NOT _re)
			list(APPEND _out "${_item}")
		endif()
	endforeach()
	set(${var} "${_out}" PARENT_SCOPE)
endfunction()

function(list_filter var regex)
	set(_out)
	foreach(_item ${ARGN})
		set(_re)
		string(REGEX MATCH "${regex}" _re "${_item}")
		if(_re)
			list(APPEND _out "${_item}")
		endif()
	endforeach()
	set(${var} "${_out}" PARENT_SCOPE)
endfunction()
