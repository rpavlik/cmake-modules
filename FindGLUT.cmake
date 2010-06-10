# - try to find glut library and include files
#  GLUT_INCLUDE_DIRS, where to find GL/glut.h, etc.
#  GLUT_LIBRARIES, the libraries to link against
#  GLUT_FOUND, If false, do not try to use GLUT.
#  GLUT_RUNTIME_LIBRARY_DIRS, path to DLL on Windows for runtime use.
#  GLUT_RUNTIME_LIBRARY, dll on Windows, for installation purposes
#
# Also defined, but not for general use are:
#  GLUT_INCLUDE_DIR, where to find GL/glut.h, etc.
#  GLUT_glut_LIBRARY = the full path to the glut library.

#=============================================================================
# Copyright 2001-2009 Kitware, Inc.
# Copyright 2009-2010 Iowa State University
#                     (Author: Ryan Pavlik <abiryan@ryand.net> )
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distributed this file outside of CMake, substitute the full
#  License text for the above reference.)

if(GLUT_FIND_QUIETLY)
	find_package(OpenGL QUIET)
else()
	find_package(OpenGL)
endif()

if(OPENGL_FOUND)
	get_filename_component(_ogl_libdir ${OPENGL_gl_LIBRARY} PATH)
	find_path(GLUT_INCLUDE_DIR
		NAMES
		GL/glut.h
		GLUT/glut.h
		glut.h
		PATHS
		${_ogl_libdir}/../include
		${GLUT_ROOT_PATH}
		${GLUT_ROOT_PATH}/include
		/usr/include/GL
		/usr/openwin/share/include
		/usr/openwin/include
		/opt/graphics/OpenGL/include
		/opt/graphics/OpenGL/contrib/libglut)

	find_library(GLUT_glut_LIBRARY
		NAMES
		glut
		glut32
		GLUT
		freeglut
		PATHS
		${_ogl_libdir}
		${GLUT_ROOT_PATH}
		${GLUT_ROOT_PATH}/Release
		/usr/openwin/lib)

endif()

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLUT
	DEFAULT_MSG
	GLUT_glut_LIBRARY
	GLUT_INCLUDE_DIR
	OPENGL_FOUND)

if(GLUT_FOUND)
	set(GLUT_LIBRARIES ${GLUT_glut_LIBRARY} ${OPENGL_LIBRARIES})
	set(GLUT_INCLUDE_DIRS ${GLUT_INCLUDE_DIR} ${OPENGL_INCLUDE_DIR})

	if(WIN32)
		get_filename_component(_basename "${GLUT_glut_LIBRARY}" NAME_WE)
		get_filename_component(_libpath "${GLUT_glut_LIBRARY}" PATH)
		find_path(GLUT_RUNTIME_LIBRARY
			NAMES
			${_basename}.dll
			glut.dll
			glut32.dll
			freeglut.dll
			HINTS
			${_libpath}
			${_libpath}/../bin)
		if(GLUT_RUNTIME_LIBRARY)
			get_filename_component(GLUT_RUNTIME_LIBRARY_DIRS
				"${GLUT_RUNTIME_LIBRARY}"
				PATH)
		else()
			set(GLUT_RUNTIME_LIBRARY_DIRS)
		endif()
	endif()

	#The following deprecated settings are for backwards compatibility with CMake1.4
	set(GLUT_LIBRARY ${GLUT_LIBRARIES})
	set(GLUT_INCLUDE_PATH ${GLUT_INCLUDE_DIR})
endif()

mark_as_advanced(GLUT_INCLUDE_DIR
	GLUT_glut_LIBRARY
	GLUT_RUNTIME_LIBRARY)
