# - try to find DCUBED library
#
#  DCUBED_LIBRARY_DIR, library search path
#  DCUBED_INCLUDE_DIR, include search path
#  DCUBED_{component}_LIBRARY, the library to link against
#  DCUBED_ENVIRONMENT
#  DCUBED_FOUND, If false, do not try to use this library.
#
# Plural versions refer to this library and its dependencies, and
# are recommended to be used instead, unless you have a good reason.
#
# Useful configuration variables you might want to add to your cache:
#  DCUBED_ROOT_DIR - A directory prefix to search
#                         (a path that contains include/ as a subdirectory)
#
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

if(NOT BITS)
	if(CMAKE_SIZEOF_VOID_P MATCHES "8")
		set(BITS 64)
	else()
		set(BITS 32)
	endif()
endif()

if(WIN32 AND MSVC)
	include(CMakeDetermineVSServicePack)
	determinevsservicepack(_sp)
	if(MSVC71)
		set(VC_VER vc71)
		set(VC_VER_LONG vc71)
	elseif(MSVC80)
		set(VC_VER vc8)
		set(VC_VER_LONG vc80)
		# FIXME TODO provide more options here
		set(D3BUILD nt8)
		if("${_sp}" STREQUAL "vc80sp1")
			set(_verstring nt8s1)
		else()
			set(_verstring nt8)
		endif()
	elseif(MSVC90)
		set(VC_VER vc9)
		set(VC_VER_LONG vc90)
		set(_verstring nt9)
	endif()

	if(BITS EQUAL 32)
		set(PLATFORM win32)
	else()
		set(PLATFORM win64)
	endif()
endif()

if(NOT DCUBED_ROOT_DIR)
	if(EXISTS "$ENV{DCUBED}" AND IS_DIRECTORY "$ENV{DCUBED}")
		set(DCUBED_ROOT_DIR "$ENV{DCUBED}")
	endif()
endif()

file(TO_CMAKE_PATH "${DCUBED_ROOT_DIR}" DCUBED_ROOT_DIR)

set(DCUBED_ROOT_DIR
	"${DCUBED_ROOT_DIR}"
	CACHE
	PATH
	"Root directory to search for DCubed")

###
# Configure DCubed
###


find_path(DCUBED_CORE_INCLUDE_DIR
	d3ew_inc/modelgate.hxx
	PATHS
	"${DCUBED_ROOT_DIR}/inc")

foreach(lib aem cdmwp d3e_base d3e_cd dcm dcm3 g3)
	find_library(DCUBED_${lib}_LIBRARY
		${lib}
		PATHS
		"${DCUBED_ROOT_DIR}/lib/${_verstring}")
	list(APPEND DCUBED_LIBRARIES ${DCUBED_${lib}_LIBRARY})
	list(APPEND DCUBED_CORE_LIBRARIES ${DCUBED_${lib}_LIBRARY})
	mark_as_advanced(DCUBED_${lib}_LIBRARY)
endforeach()

find_path(DCUBED_WRAPPER_INCLUDE_DIR
	d3ew_p/p_utils.hxx
	PATHS
	"${DCUBED_ROOT_DIR}/source/wrapper_source/")

foreach(lib d3ew_p d3ew_scene)
	find_library(DCUBED_WRAPPER_${lib}_LIBRARY
		${lib}_${D3BUILD}
		PATHS
		"${DCUBED_ROOT_DIR}/wrappers/cdmwp/${lib}")
	list(APPEND DCUBED_LIBRARIES ${DCUBED_WRAPPER_${lib}_LIBRARY})
	list(APPEND DCUBED_WRAPPER_LIBRARIES ${DCUBED_WRAPPER_${lib}_LIBRARY})
	mark_as_advanced(DCUBED_WRAPPER_${lib}_LIBRARY)
endforeach()

list(APPEND DCUBED_LIBRARIES ${DCUBED_WRAPPER_LIBRARIES})

if(NOT DCUBED_ROOT_DIR)
	get_filename_component(_path "${DCUBED_dcm_LIBRARY}" PATH)
	get_filename_component(_path "${_path}/../.." ABSOLUTE)
	set(DCUBED_ROOT_DIR
		"${DCUBED_ROOT_DIR}"
		CACHE
		PATH
		"Root directory to search for DCubed"
		FORCE)
endif()

#file(TO_NATIVE_PATH "${DCUBED_ROOT_DIR}" _d3envdir)
set(DCUBED_ENVIRONMENT "DCUBED=${DCUBED_ROOT_DIR}")

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DCubed
	DEFAULT_MSG
	DCUBED_ROOT_DIR
	DCUBED_LIBRARIES
	DCUBED_CORE_LIBRARIES
	DCUBED_CORE_INCLUDE_DIR
	DCUBED_WRAPPER_INCLUDE_DIR
	DCUBED_WRAPPER_LIBRARIES)

if(DCUBED_FOUND)
	set(DCUBED_INCLUDE_DIRS
		"${DCUBED_CORE_INCLUDE_DIR}"
		"${DCUBED_WRAPPER_INCLUDE_DIR}")
	mark_as_advanced(DCUBED_ROOT_DIR)
endif()

mark_as_advanced(DCUBED_CORE_INCLUDE_DIR DCUBED_WRAPPER_INCLUDE_DIR)
