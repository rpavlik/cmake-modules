# - Copy/parse lua source files as a custom target
#
#  include(LuaTargets)
#  add_lua_target(<target_name> <directory to copy to> [<luafile> <luafile>])
#    Relative paths for the destination directory are considered with
#    with respect to CMAKE_CURRENT_BINARY_DIR
#
#  install_lua_target(<target_name> [arguments to INSTALL(PROGRAMS ...) ])
#
# Set this variable to specify location of luac, if it is not a target:
#  LUA_TARGET_LUAC_EXECUTABLE
#
# Requires CMake 2.6 or newer (uses the 'function' command)
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright Iowa State University 2009-2010.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

if(__add_lua)
	return()
endif()
set(__add_lua YES)

include(FileCopyTargets)

function(add_lua_target _target _dest)

	if(NOT ARGN)
		message(WARNING
			"In add_lua_target call for target ${_target}, no source files were specified!")
		return()
	endif()

	if(NOT LUA_TARGET_LUAC_EXECUTABLE)
		if(TARGET luac)
			message(STATUS "luac target found, using that in add_lua_target")
			set(LUA_TARGET_LUAC_EXECUTABLE luac)
		else()
			find_executable(LUA_TARGET_LUAC_EXECUTABLE
				NAMES
				luac)
		endif()
	endif()

	if(NOT LUA_TARGET_LUAC_EXECUTABLE)
		message(FATAL_ERROR "Can't find luac: please give LUA_TARGET_LUAC_EXECUTABLE a useful value - currently ${LUA_TARGET_LUAC_EXECUTABLE}")
	endif()

	set(ALLFILES)
	foreach(fn ${ARGN})
		if(IS_ABSOLUTE "${fn}")
			set(fullpath "${fn}")
			get_filename_component(fn "${fn}" NAME)
		else()
			get_filename_component(fullpath "${CMAKE_CURRENT_SOURCE_DIR}/${fn}" ABSOLUTE)
		endif()
		add_custom_command(OUTPUT "${_dest}/${fn}"
				COMMAND
				${CMAKE_COMMAND}
				ARGS -E make_directory "${_dest}"
				COMMAND
				${CMAKE_COMMAND}
				ARGS -E copy "${fullpath}" "${_dest}"
				COMMAND
				"${LUA_TARGET_LUAC_EXECUTABLE}"
				ARGS -p "${fullpath}"
				WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
				DEPENDS "${fullpath}"
				COMMENT "Copying ${fullpath} to ${_dest}/${fn} and parsing...")
		list(APPEND ALLFILES "${_dest}/${fn}")
	endforeach()

	# Custom target depending on all the file copy commands
	add_custom_target(${_target}
		SOURCES ${ARGN}
		DEPENDS ${ALLFILES})
	if(TARGET "${LUA_TARGET_LUAC_EXECUTABLE}")
		get_property(_luac_imported TARGET "${LUA_TARGET_LUAC_EXECUTABLE}" PROPERTY IMPORTED)
		if(NOT _luac_imported)
			add_dependencies(${_target} ${LUA_TARGET_LUAC_EXECUTABLE})
		endif()
	endif()

	set_property(TARGET ${_target} PROPERTY FILE_COPY_TARGET YES)
endfunction()

function(install_lua_target)
	install_file_copy_target(${ARGN})
endfunction()
