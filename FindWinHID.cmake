# - try to find Windows HID support, part of the WDK/DDK
#
# Cache Variables: (probably not for direct use in your scripts)
#  WINHID_INCLUDE_DIR
#  WINHID_CRT_INCLUDE_DIR
#  WINHID_LIBRARY
#
# Non-cache variables you might use in your CMakeLists.txt:
#  WINHID_FOUND
#  WINHID_INCLUDE_DIRS
#  WINHID_LIBRARIES
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)
#  PrefixListGlob
#  CleanDirectoryList
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
#          Copyright Iowa State University 2009-2010
# Distributed under the Boost Software License, Version 1.0.
#    (See accompanying file LICENSE_1_0.txt or copy at
#          http://www.boost.org/LICENSE_1_0.txt)

if(NOT WIN32)
	find_package_handle_standard_args(WinHID
		"Skipping search for Windows HID on non-Windows platform"
		WIN32)
	return()
endif()

if( (NOT WINHID_ROOT_DIR) AND (NOT ENV{DDKROOT} STREQUAL "") )
	set(WINHID_ROOT_DIR "$ENV{DDKROOT}")
endif()
set(WINHID_ROOT_DIR
	"${WINHID_ROOT_DIR}"
	CACHE
	PATH
	"Directory to search")

if(CMAKE_SIZEOF_VOID_P MATCHES "8")
	set(_arch amd64)
else()
	set(_arch i386)
endif()

include(PrefixListGlob)
include(CleanDirectoryList)
prefix_list_glob(_prefixed "*/" "$ENV{SYSTEMDRIVE}/WinDDK/" "c:/WinDDK/")
clean_directory_list(_prefixed)

find_library(WINHID_LIBRARY
	NAMES
	hid
	HINTS
	"${WINHID_ROOT_DIR}"
	${_prefixed}
	PATH_SUFFIXES
	"lib/w2k/${_arch}" # Win2k min requirement
	"lib/wxp/${_arch}" # WinXP min requirement
	"lib/wnet/${_arch}" # Win Server 2003 min requirement
	"lib/wlh/${_arch}" # Win Vista ("Long Horn") min requirement
	"lib/win7/${_arch}" # Win 7 min requirement
	)

# Might want to look close to the library first for the includes.
get_filename_component(_libdir "${WINHID_LIBRARY}" PATH)
get_filename_component(_basedir "${_libdir}/../../.." ABSOLUTE)

find_path(WINHID_INCLUDE_DIR
	NAMES
	hidsdi.h
	HINTS
	"${_basedir}"
	PATHS
	"${WINHID_ROOT_DIR}"
	PATH_SUFFIXES
	inc/api)

find_path(WINHID_CRT_INCLUDE_DIR # otherwise you get weird compile errors
	NAMES
	stdio.h
	HINTS
	"${_basedir}"
	PATHS
	"${WINHID_ROOT_DIR}"
	PATH_SUFFIXES
	inc/crt
	NO_DEFAULT_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(WinHID
	DEFAULT_MSG
	WINHID_LIBRARY
	WINHID_INCLUDE_DIR
	WINHID_CRT_INCLUDE_DIR)

if(WINHID_FOUND)
	set(_winreq "Unknown")
	if(WINHID_LIBRARY MATCHES "lib/w2k")
		set(_winreq "Windows 2000")
	elseif(WINHID_LIBRARY MATCHES "lib/wxp")
		set(_winreq "Windows XP")
	elseif(WINHID_LIBRARY MATCHES "lib/wnet")
		set(_winreq "Windows Server 2003")
	elseif(WINHID_LIBRARY MATCHES "lib/wlh")
		set(_winreq "Windows Vista")
	elseif(WINHID_LIBRARY MATCHES "lib/win7")
		set(_winreq "Windows 7")
	endif()
	if(NOT "${WINHID_MIN_WINDOWS_VER}" STREQUAL "${_winreq}")
		if(NOT WinHID_FIND_QUIETLY)
			message(STATUS "Linking against WINHID_LIBRARY will enforce this minimum version: ${_winreq}")
		endif()
		set(WINHID_MIN_WINDOWS_VER "${_winreq}" CACHE INTERNAL "" FORCE)
	endif()
	set(WINHID_LIBRARIES "${WINHID_LIBRARY}")
	set(WINHID_INCLUDE_DIRS "${WINHID_CRT_INCLUDE_DIR}" "${WINHID_INCLUDE_DIR}")
	mark_as_advanced(WINHID_ROOT_DIR)
endif()

mark_as_advanced(WINHID_INCLUDE_DIR
	WINHID_CRT_INCLUDE_DIR
	WINHID_LIBRARY)
