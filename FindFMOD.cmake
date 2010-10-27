# - try to find the FMOD library
#
# FindFMOD.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  FMOD_LIBRARY
#  FMOD_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  FMOD_FOUND
#  FMOD_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  FMOD_LIBRARIES
#  FMOD_INCLUDE_DIRS
#  FMOD_LINKER_FLAGS
#
# Use this module this way:
#  find_package(FMOD)
#  include_directories(FMOD_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${FMOD_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${FMOD_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# If fmod isn't required, then neither are its dependencies
if(FMOD_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Now let's find the FMOD library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_fmod_hint QUIET fmod)
endif()

find_library(FMOD_LIBRARY
	NAMES
	fmodex64
	HINTS
	${_fmod_hint_LIBRARY_DIRS}
	PATHS
	${FMOD_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(FMOD_INCLUDE_DIR
	NAMES
	fmodex/fmod.h
	HINTS
	${_fmod_hint_INCLUDE_DIRS}
	PATHS
	${FMOD_ROOT}
	PATH_SUFFIXES
	include
)

# handle the QUIETLY and REQUIRED arguments and set FMOD_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FMOD
	DEFAULT_MSG
	FMOD_LIBRARY
	FMOD_INCLUDE_DIR)

if(FMOD_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(FMOD_LIBRARIES    ${FMOD_LIBRARY})
	set(FMOD_INCLUDE_DIRS ${FMOD_INCLUDE_DIR})
endif()

if(FMOD_FOUND OR FMOD_MARK_AS_ADVANCED)
	mark_as_advanced(FMOD_LIBRARY FMOD_INCLUDE_DIR)
endif()

# End of FindFMOD.cmake

