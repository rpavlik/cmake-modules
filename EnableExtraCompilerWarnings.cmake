# - Add flags to compile with extra warnings
#
#  enable_extra_compiler_warnings(<targetname>)
#  globally_enable_extra_compiler_warnings() - to modify CMAKE_CXX_FLAGS, etc
#    to change for all targets declared after the command, instead of per-command
#
#
# Original Author:
# 2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University - HCI Graduate Program/VRAC
#
# Additional Author:
# 2013 Kevin M. Godby <kevin@godby.org>
# http://kevin.godby.org/
# Iowa State University - HCI Graduate Program/VRAC
#
# Copyright 2009-2010, Iowa State University
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
# SPDX-License-Identifier: BSL-1.0

if(__enable_extra_compiler_warnings)
	return()
endif()
set(__enable_extra_compiler_warnings YES)

macro(_check_warning_flag _flag _flags)
	include(CheckCXXCompilerFlag)
	string(REGEX REPLACE "[^A-Za-z0-9]" "" _flagvar "${_flag}")
	check_cxx_compiler_flag(${_flag} SUPPORTS_WARNING_${_flagvar})
	if(SUPPORTS_WARNING_${_flagvar})
		set(_flags "${_flags} ${_flag}")
	endif()
endmacro()

macro(_enable_extra_compiler_warnings_flags)
	set(_flags)
	if(MSVC)
		option(COMPILER_WARNINGS_EXTREME
			"Use compiler warnings that are probably overkill."
			off)
		mark_as_advanced(COMPILER_WARNINGS_EXTREME)
		set(_flags "/W4")
		if(COMPILER_WARNINGS_EXTREME)
			set(_flags "${_flags} /Wall /wd4619 /wd4668 /wd4820 /wd4571 /wd4710")
		endif()
	else()
		include(CheckCXXCompilerFlag)
		set(_flags)
		_check_warning_flag(-W "${_flags}")
		_check_warning_flag(-Wall "${_flags}")
		_check_warning_flag(-pedantic "${_flags}")
        _check_warning_flag(-Wbool-conversion "${_flags}")
		_check_warning_flag(-Wcast-align "${_flags}")
		_check_warning_flag(-Wchar-subscripts "${_flags}")
		_check_warning_flag(-Wconversion "${_flags}")
		_check_warning_flag(-Wdisabled-optimization "${_flags}")
		_check_warning_flag(-Wdocumentation "${_flags}")
		# _check_warning_flag(-Weffc++ "${_flags}")
		_check_warning_flag(-Wempty-body "${_flags}")
		_check_warning_flag(-Wfloat-equal "${_flags}")
		_check_warning_flag(-Wformat=2 "${_flags}")
		_check_warning_flag(-Wformat-security "${_flags}")
		_check_warning_flag(-Wheader-guard "${_flags}")
		_check_warning_flag(-Wimplicit-fallthrough "${_flags}")
		_check_warning_flag(-Winit-self "${_flags}")
		_check_warning_flag(-Winline "${_flags}")
		_check_warning_flag(-Winvalid-pch "${_flags}")
		_check_warning_flag(-Wlogical-not-parentheses "${_flags}")
		_check_warning_flag(-Wloop-analysis "${_flags}")
		_check_warning_flag(-Wmissing-format-attribute "${_flags}")
		_check_warning_flag(-Wmissing-include-dirs "${_flags}")
		_check_warning_flag(-Wno-long-long "${_flags}")
		_check_warning_flag(-Wnon-virtual-dtor "${_flags}")
		_check_warning_flag(-Wold-style-cast "${_flags}")
		_check_warning_flag(-Wpacked "${_flags}")
		_check_warning_flag(-Wpointer-arith "${_flags}")
		_check_warning_flag(-Wredundant-decls "${_flags}")
		_check_warning_flag(-Wshadow "${_flags}")
		_check_warning_flag(-Wsizeof-array-argument "${_flags}")
		_check_warning_flag(-Wstrict-overflow=4 "${_flags}")
		_check_warning_flag(-Wstring-conversion "${_flags}")
		_check_warning_flag(-Wsuggest-attribute=const "${_flags}")
		_check_warning_flag(-Wswitch-enum "${_flags}")
		_check_warning_flag(-Wswitch "${_flags}")
		_check_warning_flag(-Wtrigraphs "${_flags}")
		_check_warning_flag(-Wundef "${_flags}")
		_check_warning_flag(-Wunique-enum "${_flags}")
		_check_warning_flag(-Wuninitialized "${_flags}")
		_check_warning_flag(-Wunknown-pragmas "${_flags}")
		_check_warning_flag(-Wunused "${_flags}")
		_check_warning_flag(-Wunused-label "${_flags}")
		_check_warning_flag(-Wunused-parameter "${_flags}")
		_check_warning_flag(-Wwrite-strings "${_flags}")
	endif()
endmacro()

function(enable_extra_compiler_warnings _target)
	_enable_extra_compiler_warnings_flags()
	get_target_property(_origflags ${_target} COMPILE_FLAGS)
	if(_origflags)
		set_property(TARGET
			${_target}
			PROPERTY
			COMPILE_FLAGS
			"${_flags} ${_origflags}")
	else()
		set_property(TARGET
			${_target}
			PROPERTY
			COMPILE_FLAGS
			"${_flags}")
	endif()

endfunction()

function(globally_enable_extra_compiler_warnings)
	_enable_extra_compiler_warnings_flags()
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_flags}" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_flags}" PARENT_SCOPE)
endfunction()
