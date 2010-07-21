# - try to find VRJuggler 2.2-related packages (main finder)
#  VRJUGGLER22_LIBRARY_DIRS, library search paths
#  VRJUGGLER22_INCLUDE_DIRS, include search paths
#  VRJUGGLER22_LIBRARIES, the libraries to link against
#  VRJUGGLER22_ENVIRONMENT
#  VRJUGGLER22_RUNTIME_LIBRARY_DIRS
#  VRJUGGLER22_CXX_FLAGS
#  VRJUGGLER22_DEFINITIONS
#  VRJUGGLER22_FOUND, If false, do not try to use VR Juggler 2.2.
#
# Components available to search for (uses "VRJOGL22" by default):
#  VRJOGL22
#  VRJ22
#  Gadgeteer12
#  JCCL12
#  VPR20
#  Sonix12
#  Tweek12
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
#  - If you do not specify a component, VRJOGL22(the OpenGL view manager)
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
# and Boost (from within VPR20), so most sane build environments should
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

include(CleanLibraryList)
include(CleanDirectoryList)
include(FindPackageMessage)

set(VRJUGGLER22_ROOT_DIR
	"${VRJUGGLER22_ROOT_DIR}"
	CACHE
	PATH
	"Additional root directory to search for VR Juggler and its dependencies.")
if(NOT VRJUGGLER22_ROOT_DIR)
	file(TO_CMAKE_PATH "$ENV{VJ_BASE_DIR}" VRJUGGLER22_ROOT_DIR)
endif()

# Default required components
if(NOT VRJuggler22_FIND_COMPONENTS)
	set(VRJuggler22_FIND_COMPONENTS vrjogl22)
endif()

if(VRJuggler22_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

set(VRJUGGLER22_SUBMODULES
	VRJ22
	VRJOGL22
	Gadgeteer12
	JCCL12
	VPR20
	Sonix12
	Tweek12)
string(TOUPPER "${VRJUGGLER22_SUBMODULES}" VRJUGGLER22_SUBMODULES_UC)
string(TOUPPER
	"${VRJuggler22_FIND_COMPONENTS}"
	VRJUGGLER22_FIND_COMPONENTS_UC)

# Turn a potentially messy components list into a nice one with versions.
set(VRJUGGLER22_REQUESTED_COMPONENTS)
foreach(VRJUGGLER22_LONG_NAME ${VRJUGGLER22_SUBMODULES_UC})
	# Look at requested components
	foreach(VRJUGGLER22_REQUEST ${VRJUGGLER22_FIND_COMPONENTS_UC})
		string(REGEX
			MATCH
			"${VRJUGGLER22_REQUEST}"
			VRJUGGLER22_MATCHING
			"${VRJUGGLER22_LONG_NAME}")
		if(VRJUGGLER22_MATCHING)
			list(APPEND
				VRJUGGLER22_REQUESTED_COMPONENTS
				${VRJUGGLER22_LONG_NAME})
			list(APPEND
				VRJUGGLER22_COMPONENTS_FOUND
				${VRJUGGLER22_LONG_NAME}_FOUND)
		endif()
	endforeach()
endforeach()

if(VRJUGGLER22_REQUESTED_COMPONENTS)
	list(REMOVE_DUPLICATES VRJUGGLER22_REQUESTED_COMPONENTS)
endif()

if(VRJUGGLER22_COMPONENTS_FOUND)
	list(REMOVE_DUPLICATES VRJUGGLER22_COMPONENTS_FOUND)
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

if(NOT VRJuggler22_FIND_QUIETLY
	AND NOT VRJUGGLER22_FOUND
	AND NOT "${_VRJUGGLER22_SEARCH_COMPONENTS}"	STREQUAL "${VRJUGGLER22_REQUESTED_COMPONENTS}")
	message(STATUS
		"Searching for these requested VR Juggler 2.2 components and their dependencies: ${VRJUGGLER22_REQUESTED_COMPONENTS}")
endif()

# Find components
if("${VRJUGGLER22_REQUESTED_COMPONENTS}" MATCHES "VRJOGL22" AND NOT VRJOGL22_FOUND)
	find_package(VRJOGL22 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER22_REQUESTED_COMPONENTS}" MATCHES "VRJ22" AND NOT VRJ22_FOUND)
	find_package(VRJ22 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER22_REQUESTED_COMPONENTS}" MATCHES "JCCL12" AND NOT JCCL12_FOUND)
	find_package(JCCL22 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER22_REQUESTED_COMPONENTS}" MATCHES "GADGETEER12" AND NOT GADGETEER12_FOUND)
	find_package(Gadgeteer12 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER22_REQUESTED_COMPONENTS}" MATCHES "SONIX12" AND NOT SONIX12_FOUND)
	find_package(Sonix12 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER22_REQUESTED_COMPONENTS}" MATCHES "TWEEK12" AND NOT TWEEK12_FOUND)
	find_package(Tweek12 ${_FIND_FLAGS})
endif()

if("${VRJUGGLER22_REQUESTED_COMPONENTS}" MATCHES "VPR20" AND NOT VPR20_FOUND)
	find_package(VPR20 ${_FIND_FLAGS})
endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VRJuggler22
	DEFAULT_MSG
	${VRJUGGLER22_COMPONENTS_FOUND})

if(VRJUGGLER22_FOUND)
	foreach(VRJUGGLER22_REQUEST ${VRJUGGLER22_REQUESTED_COMPONENTS})
		list(APPEND VRJUGGLER22_LIBRARIES ${${VRJUGGLER22_REQUEST}_LIBRARIES})
		list(APPEND
			VRJUGGLER22_INCLUDE_DIRS
			${${VRJUGGLER22_REQUEST}_INCLUDE_DIRS})
	endforeach()

	clean_library_list(VRJUGGLER22_LIBRARIES)

	clean_directory_list(VRJUGGLER22_INCLUDE_DIRS)

	set(_vjbase)
	set(_vjbaseclean)
	foreach(_lib ${VPR20_LIBRARY} ${VRJ22_LIBRARY} ${VRJOGL22_LIBRARY} ${JCCL12_LIBRARY} ${GADGETEER12_LIBRARY})
		get_filename_component(_libpath "${_lib}" PATH)
		get_filename_component(_abspath "${_libpath}/.." ABSOLUTE)
		list(APPEND _vjbase "${_abspath}")
	endforeach()

	clean_directory_list(_vjbase)

	set(_vrj22_have_base_dir NO)
	list(LENGTH _vjbase _vjbaselen)
	if("${_vjbaselen}" EQUAL 1 AND NOT VRJUGGLER22_VJ_BASE_DIR)
		list(GET _vjbase 0 VRJUGGLER22_VJ_BASE_DIR)
		mark_as_advanced(VRJUGGLER22_VJ_BASE_DIR)
		if(NOT VRJUGGLER22_VJ_BASE_DIR STREQUAL _vrj22_base_dir)
			unset(VRJUGGLER22_VJ_CFG_DIR)
		endif()
		set(_vrj22_have_base_dir YES)
	else()
		list(GET _vjbase 0 _calculated_base_dir)
		if(NOT
			"${_calculated_base_dir}"
			STREQUAL
			"${VRJUGGLER22_VJ_BASE_DIR}")
			message("It looks like you might be mixing VR Juggler versions... ${_vjbaselen} ${_vjbase}")
			message("If you are, fix your libraries then remove the VRJUGGLER22_VJ_BASE_DIR variable in CMake, then configure again")
			message("If you aren't, set the VRJUGGLER22_VJ_BASE_DIR variable to the desired VJ_BASE_DIR to use when running")
		else()
			if(NOT VRJUGGLER22_VJ_BASE_DIR STREQUAL _vrj22_base_dir)
				unset(VRJUGGLER22_VJ_CFG_DIR)
			endif()
			set(_vrj22_have_base_dir YES)
		endif()
	endif()
	
	set(_vrj22_base_dir "${VRJUGGLER22_VJ_BASE_DIR}")
	set(_vrj22_base_dir "${_vrj22_base_dir}" CACHE INTERNAL "" FORCE)
	
	if(_vrj22_have_base_dir)
		file(GLOB _poss_dirs ${VRJUGGLER22_VJ_BASE_DIR}/share/vrjuggler*/data/configFiles)
		find_path(VRJUGGLER22_VJ_CFG_DIR
			standalone.jconf
			PATHS
			${_poss_dirs}
			NO_DEFAULT_PATH)
		mark_as_advanced(VRJUGGLER22_VJ_CFG_DIR)
	endif()
		
	set(VRJUGGLER22_VJ_BASE_DIR
		"${VRJUGGLER22_VJ_BASE_DIR}"
		CACHE
		PATH
		"Base directory to use as VJ_BASE_DIR when running your app."
		FORCE)
	set(VRJUGGLER22_ENVIRONMENT
		"VJ_BASE_DIR=${VRJUGGLER22_VJ_BASE_DIR}"
		"JCCL_BASE_DIR=${VRJUGGLER22_VJ_BASE_DIR}"
		"SONIX_BASE_DIR=${VRJUGGLER22_VJ_BASE_DIR}"
		"TWEEK_BASE_DIR=${VRJUGGLER22_VJ_BASE_DIR}"
		"VJ_CFG_DIR=${VRJUGGLER22_VJ_CFG_DIR}")

    include(GetDirectoryList)
    
    get_directory_list(VRJUGGLER22_RUNTIME_LIBRARY_DIRS ${VRJUGGLER22_LIBRARIES})
    
	if(MSVC)
		# Needed to make linking against boost work with 2.2.1 binaries - rp20091022
		# BOOST_ALL_DYN_LINK
		set(VRJUGGLER22_DEFINITIONS "-DBOOST_ALL_DYN_LINK" "-DCPPDOM_DYN_LINK" "-DCPPDOM_AUTO_LINK")

		# Disable these annoying warnings
		# 4275: non dll-interface class used as base for dll-interface class
		# 4251: needs to have dll-interface to be used by clients of class
		# 4100: unused parameter
		# 4512: assignment operator could not be generated
		# 4127: (Not currently disabled) conditional expression in loop evaluates to constant
		
		set(VRJUGGLER22_CXX_FLAGS "/wd4275 /wd4251 /wd4100 /wd4512")
	elseif(CMAKE_COMPILER_IS_GNUCXX)
		# Silence annoying warnings about deprecated hash_map.
		set(VRJUGGLER22_CXX_FLAGS "-Wno-deprecated")

		set(VRJUGGLER22_DEFINITIONS "")
	endif()
	set(VRJUGGLER22_CXX_FLAGS
		"${VRJUGGLER22_CXX_FLAGS} ${CPPDOM_CXX_FLAGS}")

	set(VRJUGGLER22_DEFINITIONS
		"${VRJUGGLER22_DEFINITIONS}" "-DJUGGLER_DEBUG")

	set(_VRJUGGLER22_SEARCH_COMPONENTS
		"${VRJUGGLER22_REQUESTED_COMPONENTS}"
		CACHE
		INTERNAL
		"Requested components, used as a flag.")
	mark_as_advanced(VRJUGGLER22_ROOT_DIR)
endif()

mark_as_advanced(VRJUGGLER22_DEFINITIONS)
