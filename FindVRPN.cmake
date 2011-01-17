# - try to find VRPN library
#
# Cache Variables:
#  VRPN_LIBRARY
#  VRPN_SERVER_LIBRARY
#  VRPN_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  VRPN_FOUND
#  VRPN_SERVER_LIBRARIES
#  VRPN_LIBRARIES
#  VRPN_INCLUDE_DIRS
#
# VRPN_ROOT_DIR is searched preferentially for these files
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright Iowa State University 2009-2010.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

set(VRPN_ROOT_DIR
	"${VRPN_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for VRPN")

if("${CMAKE_SIZEOF_VOID_P}" MATCHES "8")
	set(_libsuffixes lib64 lib)
else()
	set(_libsuffixes lib)
endif()

###
# Configure VRPN
###

find_path(VRPN_INCLUDE_DIR
	NAMES
	vrpn_Connection.h
	PATH_SUFFIXES
	include
	include/vrpn
	HINTS
	"${VRPN_ROOT_DIR}")

find_library(VRPN_LIBRARY
	NAMES
	vrpn
	PATH_SUFFIXES
	${_libsuffixes}
	HINTS
	"${VRPN_ROOT_DIR}")

find_library(VRPN_SERVER_LIBRARY
	NAMES
	vrpnserver
	PATH_SUFFIXES
	${_libsuffixes}
	HINTS
	"${VRPN_ROOT_DIR}")

###
# Dependencies
###
set(_deps_libs)
set(_deps_includes)
set(_deps_check)

find_package(quatlib)
list(APPEND _deps_libs ${QUATLIB_LIBRARIES})
list(APPEND _deps_includes ${QUATLIB_INCLUDE_DIRS})
list(APPEND _deps_check QUATLIB_FOUND)

if(NOT WIN32)
	find_package(Threads)
	list(APPEND _deps_libs ${CMAKE_THREAD_LIBS_INIT})
	list(APPEND _deps_check CMAKE_HAVE_THREADS_LIBRARY)
endif()


# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRPN
	DEFAULT_MSG
	VRPN_LIBRARY
	VRPN_INCLUDE_DIR
	${_deps_check})

if(VRPN_FOUND)
	set(VRPN_INCLUDE_DIRS "${VRPN_INCLUDE_DIR}" ${_deps_includes})
	set(VRPN_LIBRARIES "${VRPN_LIBRARY}" ${_deps_libs})
	set(VRPN_SERVER_LIBRARIES "${VRPN_SERVER_LIBRARY}" ${_deps_libs})

	mark_as_advanced(VRPN_ROOT_DIR)
endif()

mark_as_advanced(VRPN_LIBRARY
	VRPN_SERVER_LIBRARY
	VRPN_INCLUDE_DIR)
