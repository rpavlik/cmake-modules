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
# Copyright Iowa State University 2009-2010.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

if(__add_lua)
	return()
endif()
set(__add_lua YES)

include(FileCopyTargets)

function(add_lua_target)
	add_file_copy_target(${ARGN})
endfunction()

function(install_lua_target)
	install_file_copy_target(${ARGN})
endfunction()
