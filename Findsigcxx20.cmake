# - try to find the sigc++ 2.0 library
#
# Findsigcxx20.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  SIGCXX20_LIBRARY
#  SIGCXX20_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  SIGCXX20_FOUND
#  SIGCXX20_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  SIGCXX20_LIBRARIES
#  SIGCXX20_INCLUDE_DIRS
#  SIGCXX20_LINKER_FLAGS
#
# Use this module this way:
#  find_package(sigcxx20)
#  include_directories(SIGCXX20_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${SIGCXX20_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${SIGCXX20_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#
# Dependencies:
#  none
#
# BEGIN_DOT_FILE
#  sigcxx20 [ label = "libsigc++ 2.0" ];
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# If sigcxx isn't required, then neither are its dependencies
if(sigcxx20_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Let's find the sigcxx library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_sigcxx20_hint sigc++-2.0 QUIET)
endif()

find_library(SIGCXX20_LIBRARY
	NAMES
	sigc-2.0
	HINTS
	${_sigcxx20_hint_LIBRARY_DIRS}
	${_sigcxx20_hint_LIBRARY_DIR}
	PATHS
	${SIGCXX20_ROOT}
	PATH_SUFFIXES
	lib
	lib32
	lib64
)

find_path(SIGCXX20_INCLUDE_DIR
	NAMES
	sigc++/sigc++.h
	HINTS
	${_sigcxx20_hint_INCLUDE_DIRS}
	${_sigcxx20_hint_INCLUDE_DIR}
	PATHS
	${SIGCXX20_ROOT}
	PATH_SUFFIXES
	include
	include/sigc++-2.0
)

find_path(SIGCXX20_LIB_INCLUDE_DIR
	NAMES
	sigc++config.h
	HINTS
	${_sigcxx20_hint_LIBRARY_DIRS}
	${_sigcxx20_hint_LIBRARY_DIR}
	${_sigcxx20_hint_INCLUDE_DIRS}
	${_sigcxx20_hint_INCLUDE_DIR}
	PATHS
	${SIGCXX20_ROOT}
	PATH_SUFFIXES
	include
	include/sigc++-2.0
	sigc++-2.0/include
	sigc++-2.0
)

# handle the QUIETLY and REQUIRED arguments and set SIGCXX20_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SIGCXX20
	DEFAULT_MSG
	SIGCXX20_LIBRARY
	SIGCXX20_INCLUDE_DIR
	SIGCXX20_LIB_INCLUDE_DIR)

if(SIGCXX20_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	set(SIGCXX20_LIBRARIES ${SIGCXX20_LIBRARY} ${SIGCXX20_LIBRARY})
	set(SIGCXX20_INCLUDE_DIRS ${SIGCXX20_INCLUDE_DIRS} ${SIGCXX20_INCLUDE_DIR} ${SIGCXX20_LIB_INCLUDE_DIR})
	foreach(_dep LIST ${_sigcxx20_DEPENDENCIES})
		string(TOUPPER ${_dep} _DEP)
		set(SIGCXX20_LIBRARIES ${SIGCXX20_LIBRARY} ${${_DEP}_LIBRARIES})
		set(SIGCXX20_INCLUDE_DIRS ${SIGCXX20_INCLUDE_DIRS} ${${_DEP}_INCLUDE_DIRS})
		set(SIGCXX20_LINKER_FLAGS ${SIGCXX20_LINKER_FLAGS} ${${_DEP}_LINKER_FLAGS})
	endforeach()
endif()

if(SIGCXX20_FOUND OR SIGCXX20_MARK_AS_ADVANCED)
	foreach(_dependency LIST _sigcxx20_DEPENDENCIES)
		string(TOUPPER ${_dependency} _DEPENDENCY)
		mark_as_advanced(${_DEPENDENCY}_LIBRARY ${_DEPENDENCY}_INCLUDE_DIR)
	endforeach()
	mark_as_advanced(SIGCXX20_LIBRARY SIGCXX20_INCLUDE_DIR SIGCXX20_LIB_INCLUDE_DIR)
endif()

# End of Findsigcxx20.cmake

