# - try to find the gobject 2.0 library
#
# Findgobject20.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GOBJECT20_LIBRARY
#  GOBJECT20_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GOBJECT20_FOUND
#  GOBJECT20_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  GOBJECT20_LIBRARIES
#  GOBJECT20_INCLUDE_DIRS
#  GOBJECT20_LINKER_FLAGS
#
# Use this module this way:
#  find_package(gobject20)
#  include_directories(GOBJECT20_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GOBJECT20_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${GOBJECT20_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#
# Dependencies:
#  glib-2.0
#  gthread-2.0
#
# BEGIN_DOT_FILE
#  gobject20 [ label = "GObject 2.0" ];
#  gobject20 -> glib20;
#  gobject20 -> gthread20;
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# If gobject isn't required, then neither are its dependencies
if(gobject20_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Find the dependencies for gobject-2.0
set(_gobject20_DEPENDENCIES glib20 gthread20)
foreach(_dep ${_gobject20_DEPENDENCIES})
	find_package(${_dep} ${_FIND_FLAGS})
endforeach()

# Let's find the gobject library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_gobject20_hint QUIET gobject-2.0)
endif()

find_library(GOBJECT20_LIBRARY
	NAMES
	gobject-2.0
	HINTS
	${_gobject20_hint_LIBRARY_DIRS}
	${_gobject20_hint_LIBRARY_DIR}
	PATHS
	${GOBJECT20_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

# handle the QUIETLY and REQUIRED arguments and set GOBJECT20_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GOBJECT20
	DEFAULT_MSG
	GOBJECT20_LIBRARY
	CMAKE_USE_PTHREADS_INIT
	GLIB20_FOUND)

if(GOBJECT20_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	foreach(_dep LIST ${_gobject20_DEPENDENCIES})
		string(TOUPPER ${_dep} _DEP)
		set(GOBJECT20_LIBRARIES ${GOBJECT20_LIBRARY} ${${_DEP}_LIBRARIES})
		set(GOBJECT20_INCLUDE_DIRS ${GLIB20_INCLUDE_DIRS} ${${_DEP}_INCLUDE_DIRS})
		set(GOBJECT20_LINKER_FLAGS ${GLIB20_LINKER_FLAGS} ${${_DEP}_LINKER_FLAGS})
	endforeach()
endif()

if(GOBJECT20_FOUND OR GOBJECT20_MARK_AS_ADVANCED)
	foreach(_dependency LIST _gobject20_DEPENDENCIES)
		string(TOUPPER ${_dependency} _DEPENDENCY)
		mark_as_advanced(${_DEPENDENCY}_LIBRARY ${_DEPENDENCY}_INCLUDE_DIR)
	endforeach()
	mark_as_advanced(GOBJECT20_LIBRARY GOBJECT20_INCLUDE_DIR GOBJECT20_LIB_INCLUDE_DIR)
endif()

# End of Findgobject20.cmake

