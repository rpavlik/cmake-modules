# - try to find the Google logging library
#
# FindGLog.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GLOG_LIBRARY
#  GLOG_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GLOG_FOUND
#  GLOG_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  GLOG_LIBRARIES
#  GLOG_INCLUDE_DIRS
#  GLOG_LINKER_FLAGS
#
# Use this module this way:
#  find_package(GLog)
#  include_directories(GLOG_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GLOG_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${GLOG_LINKER_FLAGS})
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

# If glog isn't required, then neither are its dependencies
if(glibmm24_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Now let's find the glog library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_glog_hint libglog)
endif()

find_library(GLOG_LIBRARY
	NAMES
	glog
	HINTS
	${_glog_hint_LIBRARY_DIRS}
	PATHS
	${GLOG_ROOT}
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
	${GLOG_ROOT}
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
endif()

if(GLOG_FOUND OR GLOG_MARK_AS_ADVANCED)
	foreach(_dependency _glog_DEPENDENCIES)
		mark_as_advanced(${_dependency}_LIBRARY)
		mark_as_advanced(${_dependency}_INCLUDE_DIR)
	endforeach()
	foreach(_cachevar
		GLOG_LIBRARY
		GLOG_INCLUDE_DIR)
		mark_as_advanced(${_cachevar})
	endforeach()
endif()

# End of FindGLog.cmake

