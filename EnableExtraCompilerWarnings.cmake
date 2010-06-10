# - Add flags to compile with extra warnings
#
#  enable_extra_compiler_warnings(<targetname>)
#  globally_enable_extra_compiler_warnings() - to modify CMAKE_CXX_FLAGS, etc
#    to change for all targets declared after the command, instead of per-command
#
#
# Original Author:
# 2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

if(__enable_extra_compiler_warnings)
	return()
endif()
set(__enable_extra_compiler_warnings YES)

macro(_enable_extra_compiler_warnings_flags)
	set(_flags)
	if(MSVC)
		set(_flags /W4)
	elseif(CMAKE_COMPILER_IS_GNUCXX)
		set(_flags "-W -Wall")
	endif()
endmacro()

function(enable_extra_compiler_warnings _target)
	_enable_extra_compiler_warnings_flags()
	get_target_property(_origflags ${_target} COMPILE_FLAGS)
	if(_origflags)
		set_property(TARGET
			${_target}
			PROPERTY
			COMPILE_FLAGS
			"${_flags} ${_origflags}")
	else()
		set_property(TARGET
			${_target}
			PROPERTY
			COMPILE_FLAGS
			"${_flags}")
	endif()

endfunction()

function(globally_enable_extra_compiler_warnings)
	_enable_extra_compiler_warnings_flags()
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_flags}" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_flags}" PARENT_SCOPE)
endfunction()
