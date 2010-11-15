# - try to find the FMOD library
#
# FindFMOD.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  FMOD_ROOT_DIR
#  FMOD_LIBRARY
#  FMOD_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  FMOD_FOUND
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
#  FindPkgConfig (CMake standard module)
#
# BEGIN_DOT_FILE
#   fmod [ label = "fmod" ];
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>
#
# License:
#   Boost 1.0 <http://www.boost.org/users/license.html>

set(FMOD_ROOT_DIR
	"${FMOD_ROOT_DIR}"
	CACHE
	PATH
	"Directory to search")

# Now let's find the FMOD library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_fmod_hint QUIET fmod)
endif()

find_library(FMOD_LIBRARY
	NAMES
	fmodex64
	HINTS
	${FMOD_ROOT_DIR}
	${_fmod_hint_LIBRARY_DIRS}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(FMOD_INCLUDE_DIR
	NAMES
	fmodex/fmod.h
	HINTS
	${FMOD_ROOT_DIR}
	${_fmod_hint_INCLUDE_DIRS}
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
	mark_as_advanced(FMOD_ROOT_DIR)
endif()

mark_as_advanced(FMOD_LIBRARY FMOD_INCLUDE_DIR)

# End of FindFMOD.cmake

