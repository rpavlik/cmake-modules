# - try to find QVRPN library
#
# Cache Variables:
#  QVRPN_LIBRARY
#  QVRPN_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  QVRPN_FOUND
#  QVRPN_LIBRARIES
#  QVRPN_INCLUDE_DIRS
#
# QVRPN_ROOT_DIR is searched preferentially for these files
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)
#
# Refactored from FindVRPN.cmake by:
# Juan Sebastian Casallas <casallas@iastate.edu>
#
# FindVRPN.cmake Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright Iowa State University 2009-2011.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

set(QVRPN_ROOT_DIR
	"${QVRPN_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for QVRPN")

if(CMAKE_SIZEOF_VOID_P MATCHES "8")
	set(_LIBSUFFIXES /lib64 /lib)
else()
	set(_LIBSUFFIXES /lib)
endif()

###
# Configure QVRPN
###

find_path(QVRPN_INCLUDE_DIR
	NAMES
	vrpn_QMainloopContainer.h
	PATH_SUFFIXES
	include
	include/qvrpn
	HINTS
	"${QVRPN_ROOT_DIR}"
	PATHS
	"${_progfiles}/QVRPN")

find_library(QVRPN_LIBRARY
	NAMES
	qvrpn
	PATH_SUFFIXES
	${_libsuffixes}
	HINTS
	"${QVRPN_ROOT_DIR}"
	PATHS
	"${_progfiles}/QVRPN")

###
# Dependencies
###
set(_deps_libs)
set(_deps_includes)
set(_deps_check)

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(QVRPN
	DEFAULT_MSG
	QVRPN_LIBRARY
	QVRPN_INCLUDE_DIR
	${_deps_check})

if(QVRPN_FOUND)
	set(QVRPN_INCLUDE_DIRS "${QVRPN_INCLUDE_DIR}" ${_deps_includes})
	set(QVRPN_LIBRARIES "${QVRPN_LIBRARY}" ${_deps_libs})

	mark_as_advanced(QVRPN_ROOT_DIR)
endif()

mark_as_advanced(QVRPN_LIBRARY
	QVRPN_INCLUDE_DIR)
