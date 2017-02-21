# - try to find the Google flags library
#
# FindGFlags.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GFLAGS_ROOT_DIR
#  GFLAGS_LIBRARY
#  GFLAGS_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GFLAGS_FOUND
#
#  GFLAGS_LIBRARIES
#  GFLAGS_INCLUDE_DIRS
#
# Use this module this way:
#  find_package(GFlags)
#  include_directories(GFLAGS_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GFLAGS_LIBRARIES})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#
# Dependencies:
#  none
#
# BEGIN_DOT_FILE
#  gflags [ label = "gflags" ];
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>
#
# License:
#   Boost 1.0 <http://www.boost.org/users/license.html>

set(GFLAGS_ROOT_DIR
	"${GFLAGS_ROOT_DIR}"
	CACHE
	PATH
	"Prefix directory for GFlags")

# If gflags isn't required, then neither are its dependencies
if(gflags_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Now let's find the gflags library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_gflags_hint QUIET gflags)
endif()

find_library(GFLAGS_LIBRARY
	NAMES
	gflags
	HINTS
	${_gflags_hint_LIBRARY_DIRS}
	PATHS
	${GFLAGS_ROOT_DIR}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(GFLAGS_INCLUDE_DIR
	NAMES
	gflags/gflags.h
	HINTS
	${_gflags_hint_INCLUDE_DIRS}
	PATHS
	${GFLAGS_ROOT_DIR}
	PATH_SUFFIXES
	include
)

# handle the QUIETLY and REQUIRED arguments and set GFLAGS_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GFLAGS
	DEFAULT_MSG
	GFLAGS_LIBRARY
	GFLAGS_INCLUDE_DIR)

if(GFLAGS_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(GFLAGS_LIBRARIES    ${GFLAGS_LIBRARY})
	set(GFLAGS_INCLUDE_DIRS ${GFLAGS_INCLUDE_DIR})
	mark_as_advanced(GFLAGS_LIBRARY GFLAGS_INCLUDE_DIR)
endif()

# End of FindGFlags.cmake

