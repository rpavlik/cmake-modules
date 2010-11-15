# - try to find the Bullet library
#
# FindBullet.cmake
#
# Cache Variables: (probably not for direct use in CMakeLists.txt)
#  BULLET_ROOT_DIR
#  BULLET_LIBRARY
#  BULLET_INCLUDE_DIR
#
# Non-cache variables you might use in your CMakeLists.txt:
#  BULLET_FOUND
#
#  BULLET_LIBRARIES
#  BULLET_INCLUDE_DIRS
#
# Use this module this way:
#  find_package(Bullet)
#  include_directories(BULLET_INCLUDE_DIRS)
#  add_executable(myapp ${SOURCES})
#  target_link_libraries(myapp ${BULLET_LIBRARIES})
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
#
# License:
#   Boost 1.0 <http://www.boost.org/users/license.html>

set(BULLET_ROOT_DIR
	"${BULLET_ROOT_DIR}"
	CACHE
	PATH
	"Prefix directory for Bullet")

# Now let's find the bullet library
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(_bullet_hint QUIET bullet)
endif()

set(bullet_components SoftBody Dynamics Collision LinearMath)
set(bullet_vars BULLET_INCLUDE_DIR)
foreach(bullet_component ${bullet_components})
	string(TOUPPER ${bullet_component} BULLET_COMPONENT)
	find_library(BULLET_${BULLET_COMPONENT}_LIBRARY
		NAMES
		Bullet${bullet_component}
		${bullet_component}
		HINTS
		${BULLET_ROOT_DIR}
		${_bullet_hint_LIBRARY_DIRS}
		PATH_SUFFIXES
		lib
		lib32
		lib64
	)
	list(APPEND bullet_vars BULLET_${BULLET_COMPONENT}_LIBRARY)
endforeach()

find_path(BULLET_INCLUDE_DIR
	NAMES
	btBulletCollisionCommon.h
	HINTS
	${BULLET_ROOT_DIR}
	${_bullet_hint_INCLUDE_DIRS}
	PATH_SUFFIXES
	include
	include/bullet
)

# handle the QUIETLY and REQUIRED arguments and set BULLET_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Bullet
	DEFAULT_MSG
	${bullet_vars})

if(BULLET_FOUND)
	# Set variables containing libraries and their dependencies
	# Always use the plural form for the variables defined by other find modules:
	# they might have dependencies too!
	foreach(bullet_component ${bullet_components})
		string(TOUPPER ${bullet_component} BULLET_COMPONENT)
		list(APPEND BULLET_LIBRARIES ${BULLET_${BULLET_COMPONENT}_LIBRARY})
	endforeach()
	set(BULLET_INCLUDE_DIRS ${BULLET_INCLUDE_DIR})
	mark_as_advanced(BULLET_ROOT_DIR)
endif()

mark_as_advanced(${bullet_vars})

# End of FindBullet.cmake

