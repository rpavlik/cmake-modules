# - try to find the glibmm 2.4 library
#
# Findglibmm24.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GLIBMM24_LIBRARY
#  GLIBMM24_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GLIBMM24_FOUND
#  GLIBMM24_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  GLIBMM24_LIBRARIES
#  GLIBMM24_INCLUDE_DIRS
#  GLIBMM24_LINKER_FLAGS
#
# Use this module this way:
#  find_package(glibmm24)
#  include_directories(GLIBMM24_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GLIBMM24_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${GLIBMM24_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#
# Dependencies:
#  gobject-2.0
#  sigc++-2.0
#
# BEGIN_DOT_FILE
#  glibmm24 [ label = "glibmm 2.4" ];
#  glibmm24 -> gobject20;
#  glibmm24 -> sigcxx20;
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# If glibmm isn't required, then neither are its dependencies
if(glibmm24_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Find the dependencies for libxml++
set(_glibmm24_DEPENDENCIES gobject20 sigcxx20)
foreach(_dep ${_glibmm24_DEPENDENCIES})
	find_package(${_dep} ${_FIND_FLAGS})
endforeach()

# Now let's find the glibmm library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_glibmm24_hint QUIET glibmm-2.4)
endif()

find_library(GLIBMM24_LIBRARY
	NAMES
	glibmm-2.4
	HINTS
	${_glibmm24_hint_LIBRARY_DIRS}
	PATHS
	${GLIBMM24_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(GLIBMM24_INCLUDE_DIR
	NAMES
	glibmm.h
	HINTS
	${_glibmm24_hint_INCLUDE_DIRS}
	PATHS
	${GLIBMM24_ROOT}
	PATH_SUFFIXES
	include
	include/glibmm-2.4
)

find_path(GLIBMM24_LIB_INCLUDE_DIR
	NAMES
	glibmmconfig.h
	HINTS
	${_glibmm24_hint_LIBRARY_DIRS}
	${_glibmm24_hint_INCLUDE_DIRS}
	PATHS
	${GLIBMM24_ROOT}
	PATH_SUFFIXES
	include
	include/glibmm-2.4
	glibmm-2.4/include
	glibmm-2.4
)

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLIBMM24
	DEFAULT_MSG
	GLIBMM24_LIBRARY
	GLIBMM24_INCLUDE_DIR
	GLIBMM24_LIB_INCLUDE_DIR
	GLIBMM24_FOUND
	GOBJECT20_FOUND
	SIGCXX20_FOUND)

if(GLIBMM24_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(GLIBMM24_LIBRARIES    ${GLIBMM24_LIBRARY})
	set(GLIBMM24_INCLUDE_DIRS ${GLIBMM24_INCLUDE_DIR} ${GLIBMM24_LIB_INCLUDE_DIR})
	foreach(_dep in ${_glibmm24_DEPENDENCIES})
		string(TOUPPER ${_dep} _DEP)
		set(GLIBMM24_LIBRARIES    ${GLIBMM24_LIBRARIES}    ${${_DEP}_LIBRARIES})
		set(GLIBMM24_INCLUDE_DIRS ${GLIBMM24_INCLUDE_DIRS} ${${_DEP}_INCLUDE_DIRS})
		set(GLIBMM24_LINKER_FLAGS ${GLIBMM24_LINKER_FLAGS} ${${_DEP}_LINKER_FLAGS})
	endforeach()
Endif()

if(GLIBMM24_FOUND OR GLIBMM24_MARK_AS_ADVANCED)
	foreach(_dependency _glibmm24_DEPENDENCIES)
		mark_as_advanced(${_dependency}_LIBRARY ${_dependency}_INCLUDE_DIR)
	endforeach()
	mark_as_advanced(GLIBMM24_LIBRARY GLIBMM24_INCLUDE_DIR GLIBMM24_LIB_INCLUDE_DIR)
endif()

# End of Findglibmm24.cmake

