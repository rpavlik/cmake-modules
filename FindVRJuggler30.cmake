# - try to find VRJuggler 3.0-related packages (main finder)
#  VRJUGGLER30_LIBRARY_DIRS, library search paths
#  VRJUGGLER30_INCLUDE_DIRS, include search paths
#  VRJUGGLER30_LIBRARIES, the libraries to link against
#  VRJUGGLER30_ENVIRONMENT
#  VRJUGGLER30_RUNTIME_LIBRARY_DIRS
#  VRJUGGLER30_CXX_FLAGS
#  VRJUGGLER30_DEFINITIONS
#  VRJUGGLER30_FOUND, If false, do not try to use VR Juggler 3.0.
#
# Components available to search for (uses "VRJOGL30" by default):
#  VRJOGL30
#  VRJ30
#  GADGETEER20
#  JCCL14
#  VPR22
#  SONIX14
#  TWEEK14
#
# Additionally, a full setup requires these packages and their Find_.cmake scripts
#  CPPDOM
#  GMTL
#
# Optionally uses Flagpoll (and FindFlagpoll.cmake)
#
# Notes on components:
#  - All components automatically include their dependencies.
#  - You can search for the name above with or without the version suffix.
#  - If you do not specify a component, VRJOGL30(the OpenGL view manager)
#    will be used by default.
#  - Capitalization of component names does not matter, but it's best to
#    pretend it does and use the above capitalization.
#  - Since this script calls find_package for your requested components and
#    their dependencies, you can use any of the variables specified in those
#    files in addition to the "summary" ones listed here, for more finely
#    controlled building and linking.
#
# This CMake script requires all of the Find*.cmake scripts for the
# components listed above, as it is only a "meta-script" designed to make
# using those scripts more developer-friendly.
#
# Useful configuration variables you might want to add to your cache:
#  (CAPS COMPONENT NAME)_ROOT_DIR - A directory prefix to search
#                         (a path that contains include/ as a subdirectory)
#
# The VJ_BASE_DIR environment variable is also searched (preferentially)
# when seeking any of the above components, as well as Flagpoll, CPPDOM,
# and Boost (from within VPR22), so most sane build environments should
# "just work."
#
# IMPORTANT: Note that you need to manually re-run CMake if you change
# this environment variable, because it cannot auto-detect this change
# and trigger an automatic re-run.
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
# Updated for VR Juggler 3.0 by:
# Brandon Newendorp <brandon@newendorp.com>

include(CleanLibraryList)
include(CleanDirectoryList)
include(FindPackageMessage)

set(VRJUGGLER30_ROOT_DIR
	"${VRJUGGLER30_ROOT_DIR}"
	CACHE
	PATH
	"Additional root directory to search for VR Juggler and its dependencies.")
if(NOT VRJUGGLER30_ROOT_DIR)
	file(TO_CMAKE_PATH "$ENV{VJ_BASE_DIR}" VRJUGGLER30_ROOT_DIR)
endif()

# Default required components
if(NOT VRJUGGLER30_FIND_COMPONENTS)
	set(VRJUGGLER30_FIND_COMPONENTS VRJOGL30)
endif()

if(VRJUGGLER30_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

set(VRJUGGLER30_SUBMODULES
	VRJ30
	VRJOGL30
	GADGETEER20
	JCCL14
	VPR22
	SONIX14
	TWEEK14)
string(TOUPPER "${VRJUGGLER30_SUBMODULES}" VRJUGGLER30_SUBMODULES_UC)
string(TOUPPER
	"${VRJUGGLER30_FIND_COMPONENTS}"
	VRJUGGLER30_FIND_COMPONENTS_UC)

# Turn a potentially messy components list into a nice one with versions.
set(VRJUGGLER30_REQUESTED_COMPONENTS)
foreach(VRJUGGLER30_LONG_NAME ${VRJUGGLER30_SUBMODULES_UC})
	# Look at requested components
	foreach(VRJUGGLER30_REQUEST ${VRJUGGLER30_FIND_COMPONENTS_UC})
		string(REGEX
			MATCH
			"${VRJUGGLER30_REQUEST}"
			VRJUGGLER30_MATCHING
			"${VRJUGGLER30_LONG_NAME}")
		if(VRJUGGLER30_MATCHING)
			list(APPEND
				VRJUGGLER30_REQUESTED_COMPONENTS
				${VRJUGGLER30_LONG_NAME})
			list(APPEND
				VRJUGGLER30_COMPONENTS_FOUND
				${VRJUGGLER30_LONG_NAME}_FOUND)
		endif()
	endforeach()
endforeach()

if(VRJUGGLER30_REQUESTED_COMPONENTS)
	list(REMOVE_DUPLICATES VRJUGGLER30_REQUESTED_COMPONENTS)
endif()

if(VRJUGGLER30_COMPONENTS_FOUND)
	list(REMOVE_DUPLICATES VRJUGGLER30_COMPONENTS_FOUND)
endif()

if(CMAKE_SIZEOF_VOID_P MATCHES "8")
	set(_VRJ_LIBSUFFIXES lib64 lib)
	set(_VRJ_LIBDSUFFIXES
		debug
		lib64/x86_64/debug
		lib64/debug
		lib64
		lib/x86_64/debug
		lib/debug
		lib)
	set(_VRJ_LIBDSUFFIXES_ONLY
		debug
		lib64/x86_64/debug
		lib64/debug
		lib/x86_64/debug
		lib/debug)
else()
	set(_VRJ_LIBSUFFIXES lib)
	set(_VRJ_LIBDSUFFIXES debug lib/i686/debug lib/debug lib)
	set(_VRJ_LIBDSUFFIXES_ONLY debug lib/i686/debug lib/debug)
endif()

if(NOT VRJUGGLER30_FIND_QUIETLY
	AND NOT VRJUGGLER30_FOUND
	AND NOT "${_VRJUGGLER30_SEARCH_COMPONENTS}"	STREQUAL "${VRJUGGLER30_REQUESTED_COMPONENTS}")
	message(STATUS
		"Searching for these requested VR Juggler 3.0 components and their dependencies: ${VRJUGGLER30_REQUESTED_COMPONENTS}")
endif()

# Find components
if("${VRJUGGLER30_REQUESTED_COMPONENTS}" MATCHES "VRJOGL30" AND NOT VRJOGL30_FOUND)
	find_package(VRJOGL30 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER30_REQUESTED_COMPONENTS}" MATCHES "VRJ30" AND NOT VRJ30_FOUND)
	find_package(VRJ30 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER30_REQUESTED_COMPONENTS}" MATCHES "JCCL14" AND NOT JCCL14_FOUND)
	find_package(JCCL23 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER30_REQUESTED_COMPONENTS}" MATCHES "GADGETEER20" AND NOT GADGETEER20_FOUND)
	find_package(GADGETEER20 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER30_REQUESTED_COMPONENTS}" MATCHES "SONIX14" AND NOT SONIX14_FOUND)
	find_package(SONIX14 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER30_REQUESTED_COMPONENTS}" MATCHES "TWEEK14" AND NOT TWEEK14_FOUND)
	find_package(TWEEK14 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER30_REQUESTED_COMPONENTS}" MATCHES "VPR22" AND NOT VPR22_FOUND)
	find_package(VPR22 ${_FIND_FLAGS})
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRJUGGLER30
	DEFAULT_MSG
	${VRJUGGLER30_COMPONENTS_FOUND})

if(VRJUGGLER30_FOUND)
	foreach(VRJUGGLER30_REQUEST ${VRJUGGLER30_REQUESTED_COMPONENTS})
		list(APPEND VRJUGGLER30_LIBRARIES ${${VRJUGGLER30_REQUEST}_LIBRARIES})
		list(APPEND
			VRJUGGLER30_INCLUDE_DIRS
			${${VRJUGGLER30_REQUEST}_INCLUDE_DIRS})
	endforeach()

	clean_library_list(VRJUGGLER30_LIBRARIES)

	clean_directory_list(VRJUGGLER30_INCLUDE_DIRS)

	set(_vjbase)
	set(_vjbaseclean)
	foreach(_lib ${VPR22_LIBRARY} ${VRJ30_LIBRARY} ${VRJOGL30_LIBRARY} ${JCCL14_LIBRARY} ${GADGETEER20_LIBRARY})
		get_filename_component(_libpath "${_lib}" PATH)
		get_filename_component(_abspath "${_libpath}/.." ABSOLUTE)
		list(APPEND _vjbase "${_abspath}")
	endforeach()

	clean_directory_list(_vjbase)

	list(LENGTH _vjbase _vjbaselen)
	if("${_vjbaselen}" EQUAL 1 AND NOT VRJUGGLER30_VJ_BASE_DIR)
		list(GET _vjbase 0 VRJUGGLER30_VJ_BASE_DIR)
		mark_as_advanced(VRJUGGLER30_VJ_BASE_DIR)
	else()
		list(GET _vjbase 0 _calculated_base_dir)
		if(NOT
			"${_calculated_base_dir}"
			STREQUAL
			"${VRJUGGLER30_VJ_BASE_DIR}")
			message("It looks like you might be mixing VR Juggler versions... ${_vjbaselen} ${_vjbase}")
			message("If you are, fix your libraries then remove the VRJUGGLER30_VJ_BASE_DIR variable in CMake, then configure again")
			message("If you aren't, set the VRJUGGLER30_VJ_BASE_DIR variable to the desired VJ_BASE_DIR to use when running")
		endif()
	endif()
	set(VRJUGGLER30_VJ_BASE_DIR
		"${VRJUGGLER30_VJ_BASE_DIR}"
		CACHE
		PATH
		"Base directory to use as VJ_BASE_DIR when running your app."
		FORCE)
	set(VRJUGGLER30_ENVIRONMENT
		"VJ_BASE_DIR=${VRJUGGLER30_VJ_BASE_DIR}"
		"JCCL_BASE_DIR=${VRJUGGLER30_VJ_BASE_DIR}"
		"SONIX_BASE_DIR=${VRJUGGLER30_VJ_BASE_DIR}"
		"TWEEK_BASE_DIR=${VRJUGGLER30_VJ_BASE_DIR}")

    include(GetDirectoryList)
    
    get_directory_list(VRJUGGLER30_RUNTIME_LIBRARY_DIRS ${VRJUGGLER30_LIBRARIES})
    
	if(MSVC)
		# Needed to make linking against boost work with 3.0 binaries - rp20091022
		# BOOST_ALL_DYN_LINK
		set(VRJUGGLER30_DEFINITIONS "-DBOOST_ALL_DYN_LINK" "-DCPPDOM_DYN_LINK" "-DCPPDOM_AUTO_LINK")

		# Disable these annoying warnings
		# 4275: non dll-interface class used as base for dll-interface class
		# 4251: needs to have dll-interface to be used by clients of class
		# 4100: unused parameter
		# 4512: assignment operator could not be generated
		# 4127: (Not currently disabled) conditional expression in loop evaluates to constant
		
		set(VRJUGGLER30_CXX_FLAGS "/wd4275 /wd4251 /wd4100 /wd4512")
	elseif(CMAKE_COMPILER_IS_GNUCXX)
		# Silence annoying warnings about deprecated hash_map.
		set(VRJUGGLER30_CXX_FLAGS "-Wno-deprecated")

		set(VRJUGGLER30_DEFINITIONS "")
	endif()
	set(VRJUGGLER30_CXX_FLAGS
		"${VRJUGGLER30_CXX_FLAGS} ${CPPDOM_CXX_FLAGS}")

	set(VRJUGGLER30_DEFINITIONS
		"${VRJUGGLER30_DEFINITIONS}" "-DJUGGLER_DEBUG")

	set(_VRJUGGLER30_SEARCH_COMPONENTS
		"${VRJUGGLER30_REQUESTED_COMPONENTS}"
		CACHE
		INTERNAL
		"Requested components, used as a flag.")
	mark_as_advanced(VRJUGGLER30_ROOT_DIR)
endif()

mark_as_advanced(VRJUGGLER30_DEFINITIONS)
