# - try to find the libxml++ 2.6 library
#
# FindXML++26.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  XMLXX26_ROOT_DIR
#  XMLXX26_LIBRARY
#  XMLXX26_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  XMLXX26_FOUND
#
#  XMLXX26_LIBRARIES
#  XMLXX26_INCLUDE_DIRS
#  XMLXX26_LINKER_FLAGS
#
# Use this module this way:
#  find_package(XMLXX26)
#  include_directories(XMLXX26_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${XMLXX26_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${XMLXX26_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#  Findglibmm24
#  FindXML2
#
# Dependencies:
#  none
#
# BEGIN_DOT_FILE
#  libxmlxx [ label = "libxml++ 2.6" ];
#  libxmlxx -> glibmm24
#  libxmlxx -> xml2
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>
#
# License:
#   Boost 1.0 <http://www.boost.org/users/license.html>

# If libxml++ isn't required, then neither are its dependencies
if(XMLXX26_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Find the dependencies for libxml++
set(_xmlxx26_DEPENDENCIES glibmm24 XML2)
foreach(_dep ${_xmlxx26_DEPENDENCIES})
	find_package(${_dep} ${_FIND_FLAGS})
endforeach()

# Now let's find the libxml++-2.6 library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_xmlxx26_hint QUIET libxml++-2.6)
endif()

find_library(XMLXX26_LIBRARY
	NAMES
	xml++-2.6
	HINTS
	${_xmlxx26_hint_LIBRARY_DIRS}
	PATHS
	${XMLXX26_ROOT_DIR}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(XMLXX26_INCLUDE_DIR
	NAMES
	libxml++/libxml++.h
	HINTS
	${_xmlxx26_hint_INCLUDE_DIRS}
	PATHS
	${XMLXX26_ROOT_DIR}
	PATH_SUFFIXES
	include
	include/libxml++-2.6
)

find_path(XMLXX26_LIB_INCLUDE_DIR
	NAMES
	libxml++config.h
	HINTS
	${_xmlxx26_hint_LIBRARY_DIRS}
	${_xmlxx26_hint_INCLUDE_DIRS}
	PATHS
	${XMLXX26_ROOT_DIR}
	PATH_SUFFIXES
	include
	include/libxml++-2.6
	libxml++-2.6/include
	libxml++-2.6
)

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(XMLXX26
	DEFAULT_MSG
	XMLXX26_LIBRARY
	XMLXX26_INCLUDE_DIR
	XMLXX26_LIB_INCLUDE_DIR
	GLIBMM24_FOUND
	XML2_FOUND)

if(XMLXX26_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(XMLXX26_LIBRARIES    ${XMLXX26_LIBRARY})
	set(XMLXX26_INCLUDE_DIRS ${XMLXX26_INCLUDE_DIR} ${XMLXX26_LIB_INCLUDE_DIR})
	foreach(_dep in ${_xmlxx26_DEPENDENCIES})
		string(TOUPPER ${_dep} _DEP)
		set(XMLXX26_LIBRARIES    ${XMLXX26_LIBRARIES}    ${${_DEP}_LIBRARIES})
		set(XMLXX26_INCLUDE_DIRS ${XMLXX26_INCLUDE_DIRS} ${${_DEP}_INCLUDE_DIRS})
		set(XMLXX26_LINKER_FLAGS ${XMLXX26_LINKER_FLAGS} ${${_DEP}_LINKER_FLAGS})
		mark_as_advanced(${_dep}_LIBRARY ${_dep}_INCLUDE_DIR)
	endforeach()
	mark_as_advanced(XMLXX26_LIBRARY XMLXX26_INCLUDE_DIR)
endif()

# End of FindXML++26.cmake

