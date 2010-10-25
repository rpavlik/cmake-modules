# - try to find the Bullet library
#
# FindBullet.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  BULLET_LIBRARY
#  BULLET_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  BULLET_FOUND
#  BULLET_MARK_AS_ADVANCED - whether to mark our vars as advanced even
#    if we don't find this library.
#
#  BULLET_LIBRARIES
#  BULLET_INCLUDE_DIRS
#  BULLET_LINKER_FLAGS
#
# Use this module this way:
#  find_package(Bullet)
#  include_directories(BULLET_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${BULLET_LIBRARIES})
#  set_property(TARGET myapp PROPERTY LINK_FLAGS ${BULLET_LINKER_FLAGS})
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (CMake standard module)
#  FindPkgConfig (CMake standard module)
#
# Dependencies:
#  none
#
# BEGIN_DOT_FILE
#  bullet [ label = "bullet" ];
# END_DOT_FILE
#
# Author:
#   Kevin M. Godby <kevin@godby.org>

# If bullet isn't required, then neither are its dependencies
if(Bullet_FIND_QUIETLY)
	set(_FIND_FLAGS "QUIET")
else()
	set(_FIND_FLAGS "")
endif()

# Now let's find the bullet library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_bullet_hint bullet)
endif()

set(bullet_components SoftBody Dynamics Collision LinearMath)
foreach(bullet_component ${bullet_components})
	string(TOUPPER ${bullet_component} BULLET_COMPONENT)
	find_library(BULLET_${BULLET_COMPONENT}_LIBRARY
		NAMES
		Bullet${bullet_component}
		${bullet_component}
		HINTS
		${_bullet_hint_LIBRARY_DIRS}
		PATHS
		${BULLET_ROOT}
		PATH_SUFFIXES
		lib
		lib32
		lib64
	)
endforeach()

find_path(BULLET_INCLUDE_DIR
	NAMES
	btBulletCollisionCommon.h
	HINTS
	${_bullet_hint_INCLUDE_DIRS}
	PATHS
	${BULLET_ROOT}
	PATH_SUFFIXES
	include
	include/boost
)

# handle the QUIETLY and REQUIRED arguments and set BULLET_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(BULLET
	DEFAULT_MSG
	BULLET_SOFTBODY_LIBRARY
	BULLET_DYNAMICS_LIBRARY
	BULLET_COLLISION_LIBRARY
	BULLET_LINEARMATH_LIBRARY
	BULLET_INCLUDE_DIR)

if(BULLET_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	foreach(bullet_component ${bullet_components})
		string(TOUPPER ${bullet_component} BULLET_COMPONENT)
		list(APPEND BULLET_LIBRARIES ${BULLET_${BULLET_COMPONENT}_LIBRARY})
	endforeach()
	set(BULLET_INCLUDE_DIRS ${BULLET_INCLUDE_DIR})
Endif()

if(BULLET_FOUND OR BULLET_MARK_AS_ADVANCED)
	foreach(_dependency _bullet_DEPENDENCIES)
		mark_as_advanced(${_dependency}_LIBRARY ${_dependency}_INCLUDE_DIR)
	endforeach()
	mark_as_advanced(BULLET_LIBRARY BULLET_INCLUDE_DIR)
endif()

# End of FindBullet.cmake

