# - Find SDL2
# Find the SDL2 headers and libraries
#
#  SDL2::SDL2 - Imported target to use for building a library
#  SDL2::SDL2main - Imported target to use if you want SDL and SDLmain.
#  SDL2_FOUND - True if SDL2 was found.
#
# Original Author:
# 2015 Ryan Pavlik <ryan.pavlik@gmail.com> <abiryan@ryand.net>
#
# Copyright Sensics, Inc. 2015.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

# Set up architectures (for windows) and prefixes (for mingw builds)
if(WIN32)
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(SDL2_LIB_PATH_SUFFIX lib/x64)
		if(NOT MSVC)
			set(SDL2_PREFIX x86_64-w64-mingw32)
		endif()
	else()
		set(SDL2_LIB_PATH_SUFFIX lib/x86)
		if(NOT MSVC)
			set(SDL2_PREFIX i686-w64-mingw32)
		endif()
	endif()
endif()
if(SDL2_PREFIX)
	set(SDL2_ORIGPREFIXPATH ${CMAKE_PREFIX_PATH})
	if(SDL2_ROOT_DIR)
		list(APPEND CMAKE_PREFIX_PATH "${SDL2_ROOT_DIR}")
	endif()
	if(CMAKE_PREFIX_PATH)
		foreach(_prefix ${CMAKE_PREFIX_PATH})
			list(APPEND CMAKE_PREFIX_PATH "${_prefix}/${SDL2_PREFIX}")
		endforeach()
	endif()
endif()

# Invoke pkgconfig for hints
find_package(PkgConfig QUIET)
set(SDL2_INCLUDE_HINTS)
set(SDL2_LIB_HINTS)
if(PKG_CONFIG_FOUND)
	pkg_search_module(SDL2PC QUIET sdl2)
	if(SDL2PC_INCLUDE_DIRS)
		set(SDL2_INCLUDE_HINTS ${SDL2PC_INCLUDE_DIRS})
	endif()
	if(SDL2PC_LIBRARY_DIRS)
		set(SDL2_LIB_HINTS ${SDL2PC_LIBRARY_DIRS})
	endif()
endif()

include(FindPackageHandleStandardArgs)

find_path(SDL2_INCLUDE_DIR
	NAMES
	SDL_haptic.h # this file was introduced with SDL2
	HINTS
	${SDL2_INCLUDE_HINTS}
	PATHS
	${SDL2_ROOT_DIR}
	ENV SDL2DIR
	PATH_SUFFIXES include include/sdl2)
find_library(SDL2_LIBRARY
	NAMES
	SDL2
	HINTS
	${SDL2_LIB_HINTS}
	PATHS
	${SDL2_ROOT_DIR}
	ENV SDL2DIR
	PATH_SUFFIXES lib ${SDL2_LIB_PATH_SUFFIX})
if(WIN32 AND SDL2_LIBRARY)
	find_file(SDL2_RUNTIME_LIBRARY
		NAMES
		SDL2.dll
		libSDL2.dll
		HINTS
		${SDL2_LIB_HINTS}
		PATHS
		${SDL2_ROOT_DIR}
		ENV SDL2DIR
		PATH_SUFFIXES bin lib ${SDL2_LIB_PATH_SUFFIX})
endif()

if(WIN32 OR ANDROID OR IOS)
	set(SDL2_EXTRA_REQUIRED SDL2_SDLMAIN_LIBRARY)
	find_library(SDL2_SDLMAIN_LIBRARY
		NAMES
		SDL2main
		PATHS
		${SDL2_ROOT_DIR}
		ENV SDL2DIR
		PATH_SUFFIXES lib ${SDL2_LIB_PATH_SUFFIX})
endif()

if(SDL2_PREFIX)
	# Restore things the way they used to be.
	set(CMAKE_PREFIX_PATH ${SDL2_ORIGPREFIXPATH})
endif()

# handle the QUIETLY and REQUIRED arguments and set QUATLIB_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SDL2
	DEFAULT_MSG
	SDL2_LIBRARY
	SDL2_INCLUDE_DIR
	${SDL2_EXTRA_REQUIRED})

if(SDL2_FOUND)
	if(WIN32 AND SDL2_RUNTIME_LIBRARY)
		add_library(SDL2::SDL2 SHARED IMPORTED)
		set_target_properties(SDL2::SDL2
			PROPERTIES
			IMPORTED_IMPLIB "${SDL2_LIBRARY}"
			IMPORTED_LOCATION "${SDL2_RUNTIME_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${SDL2_INCLUDE_DIR}"
		)
	else()
		add_library(SDL2::SDL2 STATIC IMPORTED)
		set_target_properties(SDL2::SDL2
			PROPERTIES
			IMPORTED_LOCATION "${SDL2_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${SDL2_INCLUDE_DIR}"
		)
	endif()
	add_library(SDL2::SDL2main STATIC IMPORTED)
	set(SDL2MAIN_LIBRARIES SDL2::SDL2)
	if(SDL2_SDLMAIN_LIBRARY)
		set_target_properties(SDL2::SDL2main
			PROPERTIES
			IMPORTED_LOCATION "${SDL2_SDLMAIN_LIBRARY}")
	endif()
	if(MINGW)
		list(APPEND SDL2MAIN_LIBRARIES mingw32 mwindows)
		set_target_properties(SDL2::SDL2main
			PROPERTIES
			INTERFACE_COMPILE_DEFINITIONS "main=SDL_main")
	endif()
	set_target_properties(SDL2::SDL2main
		PROPERTIES
		INTERFACE_LINK_LIBRARIES "${SDL2MAIN_LIBRARIES}")
	mark_as_advanced(SDL2_ROOT_DIR)
endif()

mark_as_advanced(SDL2_LIBRARY SDL2_RUNTIME_LIBRARY SDL2_INCLUDE_DIR SDL2_SDLMAIN_LIBRARY)
