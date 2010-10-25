# - try to find the glib 2.0 library
#
# Findglib20.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  GLIB20_LIBRARY
#  GLIB20_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GLIB20_FOUND
#  GLIB20_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  GLIB20_LIBRARIES
#  GLIB20_INCLUDE_DIRS
#  GLIB20_LINKER_FLAGS
#
# Use this module this way:
#  find_package(glib20)
#  include_directories(GLIB20_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${GLIB20_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${GLIB20_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#
# Dependencies:
#  none
#
# BEGIN_DOT_FILE
#  glib20 [ label = "Glib" ];
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# Let's find the glib library
find_package(PkgConfig)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_glib20_hint glib-2.0)
endif()

find_library(GLIB20_LIBRARY
	NAMES
	glib-2.0
	HINTS
	${_glib20_hint_LIBRARY_DIRS}
	${_glib20_hint_LIBRARY_DIR}
	PATHS
	${GLIB20_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(GLIB20_INCLUDE_DIR
	NAMES
	glib.h
	HINTS
	${_glib20_hint_INCLUDE_DIRS}
	${_glib20_hint_INCLUDE_DIR}
	PATHS
	${GLIB20_ROOT}
	PATH_SUFFIXES
	include
	include/glib-2.0
)

find_path(GLIB20_LIB_INCLUDE_DIR
	NAMES
	glibconfig.h
	HINTS
	${_glib20_hint_LIBRARY_DIRS}
	${_glib20_hint_LIBRARY_DIR}
	${_glib20_hint_INCLUDE_DIRS}
	${_glib20_hint_INCLUDE_DIR}
	PATHS
	${GLIB20_LIBRARY_DIR}/glib-2.0/include/
	${GLIB20_LIBRARY_DIR}
	${GLIB20_ROOT}
	PATH_SUFFIXES
	glib-2.0/include
	glib-2.0
)

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLIB20
	DEFAULT_MSG
	GLIB20_LIBRARY
	GLIB20_INCLUDE_DIR
	GLIB20_LIB_INCLUDE_DIR)

if(GLIB20_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(GLIB20_LIBRARIES ${GLIB20_LIBRARY})
	set(GLIB20_INCLUDE_DIRS
		${GLIB20_INCLUDE_DIR}
		${GLIB20_LIB_INCLUDE_DIR})
	set(GLIB20_LINKER_FLAGS "")
endif()

if(GLIB20_FOUND OR GLIB20_MARK_AS_ADVANCED)
	foreach(_cachevar
		GLIB20_LIBRARY
		GLIB20_INCLUDE_DIR
		GLIB20_LIB_INCLUDE_DIR)
		mark_as_advanced(${_cachevar})
	endforeach()
endif()

# End of Findglib20.cmake

