# - Try to find GMTL
# Optionally uses Flagpoll and FindFlagpoll.cmake
# Once done, this will define
#
#  GMTL_FOUND - system has GMTL
#  GMTL_INCLUDE_DIR - the GMTL include directory
#
# Useful configuration variables you might want to add to your cache:
#  GMTL_ROOT_DIR - A directory prefix to search
#                  (a path that contains include/ as a subdirectory)
#  GMTL_ADDITIONAL_VERSIONS - Additional versions (outside of 0.5.1 to 0.6.0)
#                             to use when constructing search names and paths
#  GMTL_PEER_VER - If you are using a version other than 0.6.0 as a peer lib
#  PEER_ROOT - Root dir for all peer (within-source-tree) libraries:
#  				will look in sourcetree/$PEER_ROOT/gmtl-${GMTL_PEER_VER}/include
#
# This script will use Flagpoll, if found, to provide hints to the location
# of this library, but does not use the compiler flags returned by Flagpoll
# directly.
#
# VR Juggler requires this package, so this Find script takes that into
# account when determining where to search for the desired files.
# The VJ_BASE_DIR environment variable is searched (preferentially)
# when searching for this package, so most sane VR Juggler build environments
# should "just work."  Note that you need to manually re-run CMake if you
# change this environment variable, because it cannot auto-detect this change
# and trigger an automatic re-run.
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

set(_HUMAN "GMTL")
set(_HEADER gmtl/gmtl.h)
set(_FP_PKG_NAME gmtl)
if(NOT DEFINED GMTL_PEER_VER)
	set(GMTL_PEER_VER 0.6.0)
endif()

set(GMTL_VERSIONS
	0.5.1
	0.5.2
	0.5.3
	0.5.4
	0.6.0
	${GMTL_ADDITIONAL_VERSIONS})
set(GMTL_DIRS)
foreach(_version ${GMTL_VERSIONS})
	list(APPEND GMTL_DIRS gmtl-${_version})
	list(APPEND GMTL_HEADER_DIRS include/gmtl-${_version})
endforeach()

include(SelectLibraryConfigurations)
include(CreateImportedTarget)
include(CleanDirectoryList)

# Try flagpoll.
find_package(Flagpoll QUIET)

if(FLAGPOLL)
	flagpoll_get_include_dirs(${_FP_PKG_NAME})
endif()

set(GMTL_ROOT_DIR
	"${GMTL_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for GMTL")
if(DEFINED VRJUGGLER22_ROOT_DIR)
	mark_as_advanced(GMTL_ROOT_DIR)
endif()
if(NOT GMTL_ROOT_DIR)
	set(GMTL_ROOT_DIR "${VRJUGGLER22_ROOT_DIR}")
endif()

set(_ROOT_DIR "${GMTL_ROOT_DIR}")

# Include dir
find_path(GMTL_INCLUDE_DIR
	NAMES
	${_HEADER}
	HINTS
	${${_FP_PKG_NAME}_FLAGPOLL_INCLUDE_DIRS}
	PATHS
	"${_ROOT_DIR}"
	PATH_SUFFIXES
	${GMTL_DIRS}
	${GMTL_HEADER_DIRS}
	include/
	DOC
	"GMTL include path")

# Search in peer library directory
if(NOT GMTL_INCLUDE_DIR)

	# Default peer library root
	if(NOT PEER_ROOT)
		set(PEER_ROOT
			"${CMAKE_SOURCE_DIR}/peer"
			CACHE
			PATH
			"The root directory for bundled peer libraries.")
		mark_as_advanced(PEER_ROOT)
	endif()

	if(NOT GMTL_FIND_QUIETLY)
		message(STATUS
			"Searching for ${_HUMAN} in local peer directory: ${PEER_ROOT}/${GMTL_DIR}/")
	endif()

	find_path(GMTL_INCLUDE_DIR
		NAMES
		${_HEADER}
		PATHS
		${PEER_ROOT}/gmtl-${GMTL_PEER_VER}/include)

endif()


# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GMTL DEFAULT_MSG GMTL_INCLUDE_DIR)

if(GMTL_FOUND)
	set(GMTL_INCLUDE_DIRS ${GMTL_INCLUDE_DIR})
	mark_as_advanced(GMTL_ROOT_DIR)
endif()

mark_as_advanced(GMTL_INCLUDE_DIR)
