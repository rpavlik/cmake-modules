# - Remove the Debug and MinSizeRel configurations
#
# Requires these CMake modules:
#  no additional modules required
#
# Original Author:
# 2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#


if(__remove_configurations)
	return()
endif()
set(__remove_configurations YES)

if(CMAKE_CONFIGURATION_TYPES AND NOT __CONFIGURATIONS_REMOVED)
    set(CMAKE_CONFIGURATION_TYPES "Release;RelWithDebInfo")
	set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING
        "Reset the configurations to what we need" FORCE)
	set(__CONFIGURATIONS_REMOVED YES CACHE INTERNAL "" FORCE)
endif()
