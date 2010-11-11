# - Copy lua source files as a custom target
#
#  include(LuaTargets)
#  add_lua_target(<target_name> <directory to copy to> [<luafile> <luafile>])
#    Relative paths for the destination directory are considered with
#    with respect to CMAKE_CURRENT_BINARY_DIR
#
#  install_lua_target(<target_name> [arguments to INSTALL(PROGRAMS ...) ])
#
#
# Requires CMake 2.6 or newer (uses the 'function' command)
#
# Original Author:
# 2009-2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#
#          Copyright Iowa State University 2009-2010
# Distributed under the Boost Software License, Version 1.0.
#    (See accompanying file LICENSE_1_0.txt or copy at
#          http://www.boost.org/LICENSE_1_0.txt)

if(__add_lua)
	return()
endif()
set(__add_lua YES)

define_property(TARGET
	PROPERTY
	LUA_TARGET
	BRIEF_DOCS
	"Lua target"
	FULL_DOCS
	"Is this a Lua target created by add_lua_target?")

function(add_lua_target _target _dest)
	if(NOT ARGN)
		message(WARNING
			"In add_lua_target call for target ${_target}, no Lua files were specified!")
		return()
	endif()

	set(ALLFILES)
	foreach(luafile ${ARGN})
		if(IS_ABSOLUTE "${luafile}")
			set(luapath "${luafile}")
			get_filename_component(luafile "${luafile}" NAME)
		else()
			set(luapath "${CMAKE_CURRENT_SOURCE_DIR}/${luafile}")
		endif()
		add_custom_command(OUTPUT "${_dest}/${luafile}"
				COMMAND
				${CMAKE_COMMAND}
				ARGS -E make_directory "${_dest}"
				COMMAND
				${CMAKE_COMMAND}
				ARGS -E copy "${luapath}" "${_dest}"
				WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
				DEPENDS "${luapath}"
				COMMENT "Copying ${luapath} to ${_dest}/${luafile}")
		list(APPEND ALLFILES "${_dest}/${luafile}")
	endforeach()

	# Custom target depending on all the lua file commands
	add_custom_target(${_target}
		SOURCES ${ARGN}
		DEPENDS ${ALLFILES})

	set_property(TARGET ${_target} PROPERTY LUA_TARGET YES)
endfunction()

function(install_lua_target _target)
	get_target_property(_isLua ${_target} LUA_TARGET)
	if(NOT _isLua)
		message(WARNING
			"install_lua_target called on a target not created with add_lua_target!")
		return()
	endif()

	# Get sources
	get_target_property(_srcs ${_target} SOURCES)

	# Remove the "fake" file forcing build
	list(REMOVE_AT _srcs 0)

	# Forward the call to install
	install(PROGRAMS ${_srcs} ${ARGN})
endfunction()
