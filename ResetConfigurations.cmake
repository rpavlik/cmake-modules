# - Re-set the available configurations to just RelWithDebInfo and Release
#
# Requires these CMake modules:
#  no additional modules required
#
# Original Author:
# 2010 Ryan Pavlik <rpavlik@iastate.edu> <abiryan@ryand.net>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC
#


if(__reset_configurations)
	return()
endif()
set(__reset_configurations YES)

if(CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES "RelWithDebInfo;Release")
	set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING
        "Reset the configurations to what we need" FORCE)
endif()
