# - try to find the Google flags library
#
# FindGFlags.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GFLAGS_LIBRARY
#  GFLAGS_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GFLAGS_FOUND
#  GFLAGS_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  GFLAGS_LIBRARIES
#  GFLAGS_INCLUDE_DIRS
#  GFLAGS_LINKER_FLAGS
#
# Use this module this way:
#  find_package(GFlags)
#  include_directories(GFLAGS_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GFLAGS_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${GFLAGS_LINKER_FLAGS})
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

# If gflags isn't required, then neither are its dependencies
if(glibmm24_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Now let's find the gflags library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_gflags_hint gflags)
endif()

find_library(GFLAGS_LIBRARY
	NAMES
	gflags
	HINTS
	${_gflags_hint_LIBRARY_DIRS}
	PATHS
	${GFLAGS_ROOT}
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
	${GFLAGS_ROOT}
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
Endif()

if(GFLAGS_FOUND OR GFLAGS_MARK_AS_ADVANCED)
	foreach(_dependency _gflags_DEPENDENCIES)
		mark_as_advanced(${_dependency}_LIBRARY)
		mark_as_advanced(${_dependency}_INCLUDE_DIR)
	endforeach()
	foreach(_cachevar
		GFLAGS_LIBRARY
		GFLAGS_INCLUDE_DIR)
		mark_as_advanced(${_cachevar})
	endforeach()
endif()

# End of FindGFlags.cmake

