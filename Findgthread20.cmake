# - try to find the gthread 2.0 library
#
# Findgthread20.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GTHREAD20_LIBRARY
#  GTHREAD20_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GTHREAD20_FOUND
#  GTHREAD20_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  GTHREAD20_LIBRARIES
#  GTHREAD20_INCLUDE_DIRS
#  GTHREAD20_LINKER_FLAGS
#
# Use this module this way:
#  find_package(gthread20)
#  include_directories(GTHREAD20_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GTHREAD20_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${GTHREAD20_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#  FindThreads (CMake standard module)
#
# Dependencies:
#  none
#
# BEGIN_DOT_FILE
#  gthread20 [ label = "GThread 2.0" ];
#  gthread20 -> glib20;
#  gthread20 -> pthread;
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# If gthread isn't required, then neither are its dependencies
if(gthread20_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Find the dependencies for libxml++
set(_gthread20_DEPENDENCIES glib20)
find_package(glib20 ${_FIND_FLAGS})

# We also require pthread
set(CMAKE_THREAD_PREFER_PTHREADS 1)
find_package(Threads REQUIRED)

# Let's find the gthread library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_gthread20_hint QUIET gthread-2.0)
endif()

find_library(GTHREAD20_LIBRARY
	NAMES
	gthread-2.0
	HINTS
	${_gthread20_hint_LIBRARY_DIRS}
	${_gthread20_hint_LIBRARY_DIR}
	PATHS
	${GTHREAD20_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_library(RT_LIBRARY
	NAMES
	rt
	HINTS
	${_gthread20_hint_LIBRARY_DIRS}
	${_gthread20_hint_LIBRARY_DIR}
	PATHS
	${GTHREAD20_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

# handle the QUIETLY and REQUIRED arguments and set GTHREAD20_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GTHREAD20
	DEFAULT_MSG
	GTHREAD20_LIBRARY
	CMAKE_USE_PTHREADS_INIT
	GLIB20_FOUND)

if(GTHREAD20_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(GTHREAD20_LIBRARIES ${GTHREAD20_LIBRARY} ${GLIB20_LIBRARIES} ${RT_LIBRARY} ${CMAKE_THREAD_LIBS_INIT})
	set(GTHREAD20_INCLUDE_DIRS ${GLIB20_INCLUDE_DIRS})
	set(GTHREAD20_LINKER_FLAGS ${GLIB20_LINKER_FLAGS} ${CMAKE_THREAD_LIBS_INIT})
endif()

if(GTHREAD20_FOUND OR GTHREAD20_MARK_AS_ADVANCED)
	foreach(_dependency LIST _gthread20_DEPENDENCIES)
		string(TOUPPER ${_dependency} _DEPENDENCY)
		mark_as_advanced(${_DEPENDENCY}_LIBRARY ${_DEPENDENCY}_INCLUDE_DIR)
	endforeach()
	mark_as_advanced(GTHREAD20_LIBRARY GTHREAD20_INCLUDE_DIR GTHREAD20_LIB_INCLUDE_DIR)
endif()

# End of Findgthread20.cmake

