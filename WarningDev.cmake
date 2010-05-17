# - Print a developer warning, using author_warning if we have cmake 2.8
#
#  warning_dev("your desired message")
#
# Original Author:
# 2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

function(warning_dev _yourmsg)
	if("1.${CMAKE_VERSION}" VERSION_LESS "1.2.8.0")
		# CMake version <2.8.0
		message(STATUS
			"The following is a developer warning - end users may ignore it")
		message(STATUS "Dev Warning: ${_yourmsg}")
	else()
		message(AUTHOR_WARNING "${_yourmsg}")
	endif()
endfunction()
