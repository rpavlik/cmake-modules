# - try to find the Google logging library
#
# FindGLog.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GLOG_ROOT_DIR
#  GLOG_LIBRARY
#  GLOG_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GLOG_FOUND
#
#  GLOG_LIBRARIES
#  GLOG_INCLUDE_DIRS
#
# Use this module this way:
#  find_package(GLog)
#  include_directories(GLOG_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GLOG_LIBRARIES})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#
# Dependencies:
#  none
#
# BEGIN_DOT_FILE
#  glog [ label = "glog" ];
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>
#
# License:
#   Boost 1.0 <http://www.boost.org/users/license.html>

set(GLOG_ROOT_DIR
	"${GLOG_ROOT_DIR}"
	CACHE
	PATH
	"Prefix directory for Google logging library")

# If glog isn't required, then neither are its dependencies
if(glibmm24_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Now let's find the glog library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_glog_hint QUIET libglog)
endif()

find_library(GLOG_LIBRARY
	NAMES
	glog
	HINTS
	${_glog_hint_LIBRARY_DIRS}
	PATHS
	${GLOG_ROOT_DIR}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(GLOG_INCLUDE_DIR
	NAMES
	glog/logging.h
	HINTS
	${_glog_hint_INCLUDE_DIRS}
	PATHS
	${GLOG_ROOT_DIR}
	PATH_SUFFIXES
	include
)

# handle the QUIETLY and REQUIRED arguments and set GLOG_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLOG
	DEFAULT_MSG
	GLOG_LIBRARY
	GLOG_INCLUDE_DIR)

if(GLOG_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(GLOG_LIBRARIES    ${GLOG_LIBRARY})
	set(GLOG_INCLUDE_DIRS ${GLOG_INCLUDE_DIR})
	foreach(_dependency _glog_DEPENDENCIES)
		mark_as_advanced(${_dependency}_LIBRARY ${_dependency}_INCLUDE_DIR)
	endforeach()
	mark_as_advanced(GLOG_LIBRARY GLOG_INCLUDE_DIR)
endif()

# End of FindGLog.cmake

